Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE2D7B58F9
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 19:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbjJBRAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 13:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238636AbjJBRAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 13:00:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D360B107
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 10:00:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a213b4d0efso89189837b3.2
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 10:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696266040; x=1696870840; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rcmSXpEr7h/7NYLqS6yAhuk57JUF4crLTtfNbWK9HLs=;
        b=TkY+hPKlYAW/93Dxy78mYXFO8KhuN4bu4rUDwR3IqpnivLjCRWrlkicQGe8H3fjDK7
         uY4Tt0qjFEKDDh8KR5myk8/a+0Qa6w32Se7k4XbeDTcbIcOqDj8olt+97hF0xwsiTEo5
         NX4V6g3cPtqAi9vgGHa0NS/2VowhoY2e9E5JgUIzPJn6Iuc5Ll2Bf4ioq/0cKkqSO3SM
         PQ5u+ZrKVN9bGpomeLV7pSj1eZJEOJdwfuSgBBOSkjDld7IPXGqTd5B8Zlu+mJ4dLHhl
         7jwwOGIAwNRL/Xml+J4SnLdqfZdQOpDNrPSsmJMAmBlJlm+50qD3XzxxrYF+SBI+a67j
         CxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696266040; x=1696870840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rcmSXpEr7h/7NYLqS6yAhuk57JUF4crLTtfNbWK9HLs=;
        b=Q2eoWkBZG99r1SKP/KQSmiuHobDytZUt733R2FPo7Nvj9dKmYw44PYmdwfsGhW+n8Z
         uOmurjMeFZpRTcxYUkIxJJqLfZm0c4w/kyXMpjL8j8SqNI+pkq1J3byBAohV4nHLQq7t
         SZRkJ1gh46itTB8eBkPwFXd5mEf4snKxbrOya18/PR5fIjTOgz3TlCUXxwjnbiSDXVIY
         0x1WxiUQMfk+i/YKhGJ2/W82iBS+b9W8K/GnGS8r8fkpzwe5OHAUolm9EKDWv+/27cig
         PKDlKDsuh+/ihwXs0xjmFR4uEtCCtvmL3ZbPmYQZRHeDtsMtdwkcBUBceRVFUlAoNRyG
         GFfw==
X-Gm-Message-State: AOJu0Ywx/KCciiTUl0NBu4Rv5yj9+MPQLwvaUL8EwS4X8cRpeHgzAYFI
        YL1rZijBL+l+EXYn0TppPFp8EGDENxY=
X-Google-Smtp-Source: AGHT+IFwUHLWrCdrNYcMoc0a+MUfKvL6DTsPdvL+2V9nsx1Py05xH7B7ko+5UCpV1sitco+ERQsUJp42Lcg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:aa48:0:b0:59b:eace:d467 with SMTP id
 z8-20020a81aa48000000b0059beaced467mr231254ywk.3.1696266040026; Mon, 02 Oct
 2023 10:00:40 -0700 (PDT)
Date:   Mon, 2 Oct 2023 10:00:38 -0700
In-Reply-To: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
Mime-Version: 1.0
References: <f21ee3bd852761e7808240d4ecaec3013c649dc7.camel@infradead.org>
Message-ID: <ZRr3NvZg4OiXyjoq@google.com>
Subject: Re: [PATCH v3] KVM: x86: Use fast path for Xen timer delivery
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm <kvm@vger.kernel.org>, Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 30, 2023, David Woodhouse wrote:
> @@ -146,6 +160,14 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
>  
>  static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 delta_ns)
>  {
> +	/*
> +	 * Avoid races with the old timer firing. Checking timer_expires
> +	 * to avoid calling hrtimer_cancel() will only have false positives
> +	 * so is fine.
> +	 */
> +	if (vcpu->arch.xen.timer_expires)
> +		hrtimer_cancel(&vcpu->arch.xen.timer);
> +
>  	atomic_set(&vcpu->arch.xen.timer_pending, 0);
>  	vcpu->arch.xen.timer_expires = guest_abs;
>  
> @@ -1019,9 +1041,36 @@ int kvm_xen_vcpu_get_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  		break;
>  
>  	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> +		/*
> +		 * Ensure a consistent snapshot of state is captured, with a
> +		 * timer either being pending, or the event channel delivered
> +		 * to the corresponding bit in the shared_info. Not still
> +		 * lurking in the timer_pending flag for deferred delivery.
> +		 * Purely as an optimisation, if the timer_expires field is
> +		 * zero, that means the timer isn't active (or even in the
> +		 * timer_pending flag) and there is no need to cancel it.
> +		 */

Ah, kvm_xen_start_timer() zeros timer_pending.

Given that, shouldn't it be impossible for xen_timer_callback() to observe a
non-zero timer_pending value?  E.g. couldn't this code WARN?

	if (atomic_read(&vcpu->arch.xen.timer_pending))
		return HRTIMER_NORESTART;

Obviously not a blocker for this patch, I'm mostly just curious to know if I'm
missing something.
