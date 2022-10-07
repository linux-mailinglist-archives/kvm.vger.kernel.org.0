Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D825F7DA0
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 21:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJGTJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 15:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJGTI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 15:08:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30635D25AA
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 12:08:58 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 3so4154357pfw.4
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 12:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+DrW1P6tHKxbLJ9xF03lHZTWkKXQN8rQUG02UrFZZdc=;
        b=rBAKikDLa9U0albRSC4I6W02gfkZVWvJ33fRLSk/jNqe5JtnOG4dqH6LgvWvDl7aLL
         jPZSMpV+h7jWCFlyU0k40WnOxOpVza1rN6Niujx8kaGLYctifauSKKBthFMXzWMEjiub
         d738Wf5AoUEYjEpphXttWPx9WrzTiOVESu3oVBdnkRpvzcyOUZ/gYDplQpbL+6+yWwFL
         de/fXhGclyyEHbeNFc91Yd1UxPZkeFJONCVJ2+tcC3mXf2IVpn+MX5VxQGeZXSHM5//d
         zZNxF7IPCMyD+lIxRQ21wYaGFI8/MZaN2HKd2Mhz1DTkJ4fHKLW0oMNYM1JhqxA0jjXg
         YSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DrW1P6tHKxbLJ9xF03lHZTWkKXQN8rQUG02UrFZZdc=;
        b=jKea4ipPe5cpR9l2cMvtWbSWysPvLO1Eesc5K1jUxIB6Wl5e40T/ntw3sB1WAZEgH+
         l4FjG7J737b8TaC6QcchgKTrFCRaIWMics8BK9pXvFOd0i7kRoSSRhAujyiYu5EroKlg
         auW1ulPIxivc1LihTZaS1ew06rohpUXbVzcv17/rfzEoTLixgPpajqRKoDZBICEXBFlM
         CKGnvQ9EUk3Ovg/iFyhyN27QqwMIDaZZXSFJlcGKiCc+aHexiow0s4aHqVDnFdc5anRU
         3kZ3vJtsCBN393zPOsuarh6OOUxyk+18NycMNmWq3+t4BLcPw3PiNzziR+aWgOHbciBF
         SUZw==
X-Gm-Message-State: ACrzQf3RxjCowoIF4ofAprlbPDzYXaZlgr5O/sGREliCh4S2fsDGeug9
        w0EC6Vwu7xGVXbxYRjXmlvcJqg==
X-Google-Smtp-Source: AMsMyM5gNPGubV3c6CnxnVAAiBzwVAr8vSRHeO8b4efZyvOUnxAvKjyzYdrUNFj5RbuUuQayAAXOaA==
X-Received: by 2002:a63:6986:0:b0:43c:8417:8dac with SMTP id e128-20020a636986000000b0043c84178dacmr5772132pgc.286.1665169737576;
        Fri, 07 Oct 2022 12:08:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z4-20020a623304000000b005629b223157sm1993142pfz.174.2022.10.07.12.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 12:08:56 -0700 (PDT)
Date:   Fri, 7 Oct 2022 19:08:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Y0B5RFI25TotwWHT@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915101049.187325-2-shivam.kumar1@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 15, 2022, Shivam Kumar wrote:
> @@ -542,6 +545,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>  	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
>  }
>  
> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_run *run = vcpu->run;
> +	u64 dirty_quota = READ_ONCE(run->dirty_quota);
> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> +
> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> +		return 1;
> +
> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +	run->dirty_quota_exit.count = pages_dirtied;
> +	run->dirty_quota_exit.quota = dirty_quota;
> +	return 0;

Dead code.

> +}

...

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 584a5bab3af3..f315af50037d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3298,18 +3298,36 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
>  }
>  EXPORT_SYMBOL_GPL(kvm_clear_guest);
>  
> +static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)

Ouch, sorry.  I suspect you got this name from me[*].  That was a goof on my end,
I'm 99% certain I copy-pasted stale code, i.e. didn't intended to suggest a
rename.

Let's keep kvm_vcpu_check_dirty_quota(), IMO that's still the least awful name.

[*] https://lore.kernel.org/all/Yo+82LjHSOdyxKzT@google.com

> +{
> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> +
> +	if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
> +		return;
> +
> +	/*
> +	 * Snapshot the quota to report it to userspace.  The dirty count will be
> +	 * captured when the request is processed.
> +	 */
> +	vcpu->dirty_quota = dirty_quota;
> +	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);

Making the request needs to be guarded with an arch opt-in.  Pending requests
prevent KVM from entering the guest, and so making a request that an arch isn't
aware of will effectively hang the vCPU.  Obviously userspace would be shooting
itself in the foot by setting run->dirty_quota in this case, but KVM shouldn't
hand userspace a loaded gun and help them aim.

My suggestion from v1[*] about not forcing architectures to opt-in was in the
context of a request-less implementation where dirty_quota was a nop until the
arch took action.

And regardless of arch opt-in, I think this needs a capability so that userspace
can detect KVM support.

I don't see any reason to wrap the request or vcpu_run field, e.g. something like
this should suffice:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ea5847d22aff..93362441215b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3298,8 +3298,9 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
        u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
 
        if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
@@ -3311,6 +3312,7 @@ static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
         */
        vcpu->dirty_quota = dirty_quota;
        kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
+#endif
 }
 
 void mark_page_dirty_in_slot(struct kvm *kvm,
@@ -4507,6 +4509,8 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
        case KVM_CAP_BINARY_STATS_FD:
        case KVM_CAP_SYSTEM_EVENT_DATA:
                return 1;
+       case KVM_CAP_DIRTY_QUOTA:
+               return !!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_QUOTA);
        default:
                break;
        }


[*] https://lore.kernel.org/all/YZaUENi0ZyQi%2F9M0@google.com
