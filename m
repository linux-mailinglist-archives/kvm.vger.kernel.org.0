Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E9B5179D3
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 00:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiEBWR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 18:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiEBWRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 18:17:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD61E2AE1
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 15:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651529661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xl6Xpdm3WlzJY8Flkv4/tA3bvvDEz6eyxdpQ2Cyhu6k=;
        b=M/6HZC+eszNtlEYi99Cy5cqAK8VMKIo3XddcpyuYB0R835h+WtY2/6UJK0hkM308AQ7rpo
        ad0pb7FLqmVfzyFz97dj18cODIdkPKLe3RirwRB0MqVMINT9zoItP99FCqqEys3bYfklKs
        5kYnpe5h0hlTqBxGV6MPC6UI8pTT31M=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-1yjBhZCINjO60aOanfqZSQ-1; Mon, 02 May 2022 18:14:20 -0400
X-MC-Unique: 1yjBhZCINjO60aOanfqZSQ-1
Received: by mail-il1-f198.google.com with SMTP id v11-20020a056e0213cb00b002cbcd972206so7959436ilj.11
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 15:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xl6Xpdm3WlzJY8Flkv4/tA3bvvDEz6eyxdpQ2Cyhu6k=;
        b=dW1/ZCI5ZY1BeeJRG1kSGH34B+hYg4x22xKVUvExyLxrg0snMVB/1FNq7EXOyn6V10
         cr+4LQs4H/RTK+42zTrz6OMP0LJJGPbpJ5ik3aNnA0a3a99rGDcuof0j0eHQoQDQGPYY
         Ae+xDFS6tue35wJhMrxVj+/4Nardp4gWuvqFIAcZ8JXNevlWsx/CCssBf6QEaTS+C/X2
         46w43YmINR2I8pJJcHrKg3lMtI33Iyd6QtoV1ZiRME/s+CiU2Q01XGg/d37Z69Ui4+SL
         pwjUngFi4pxp03cYBahdo6m34az4l9zJFC/eY+0DUXn7aIgOAyJ876mdWnukzJvPciUf
         3ORA==
X-Gm-Message-State: AOAM532jsJZ2gsfpf1M7mU7r5YA/aq8Rdmz9ruV7eDBFGsCYWzRivQhh
        n+6nAYeIske3XO0tCPbqch1leNwGK6gsmRxnUnJ0ISW7IKunygJoOIpoRQPbrh+fgnYYsYlM0wl
        aDlCu5YFgd3ZD
X-Received: by 2002:a05:6e02:170c:b0:2cd:bac2:667f with SMTP id u12-20020a056e02170c00b002cdbac2667fmr5375105ill.14.1651529659641;
        Mon, 02 May 2022 15:14:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4f/QticTUJHNM8NJp6hUrgYGqHh++mP5pRLnkkpYYlvtmEzG3xnz/8HPgCyPk5SrOa/hi4g==
X-Received: by 2002:a05:6e02:170c:b0:2cd:bac2:667f with SMTP id u12-20020a056e02170c00b002cdbac2667fmr5375101ill.14.1651529659440;
        Mon, 02 May 2022 15:14:19 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id p10-20020a6bce0a000000b0065a47e16f54sm2438437iob.38.2022.05.02.15.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 15:14:19 -0700 (PDT)
Date:   Mon, 2 May 2022 18:14:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YnBXuXTcX2OC6fQU@xz-m1.local>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220306220849.215358-2-shivam.kumar1@nutanix.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Shivam,

On Sun, Mar 06, 2022 at 10:08:48PM +0000, Shivam Kumar wrote:
> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
> +{
> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> +	struct kvm_run *run = vcpu->run;
> +
> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> +		return 1;
> +
> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +	run->dirty_quota_exit.count = pages_dirtied;
> +	run->dirty_quota_exit.quota = dirty_quota;

Pure question: why this needs to be returned to userspace?  Is this value
set from userspace?

> +	return 0;
> +}

The other high level question is whether you have considered using the ring
full event to achieve similar goal?

Right now KVM_EXIT_DIRTY_RING_FULL event is generated when per-vcpu ring
gets full.  I think there's a problem that the ring size can not be
randomly set but must be a power of 2.  Also, there is a maximum size of
ring allowed at least.

However since the ring size can be fairly small (e.g. 4096 entries) it can
still achieve some kind of accuracy.  For example, the userspace can
quickly kick the vcpu back to VM_RUN only until it sees that it reaches
some quota (and actually that's how dirty-limit is implemented on QEMU,
contributed by China Telecom):

https://lore.kernel.org/qemu-devel/cover.1646243252.git.huangy81@chinatelecom.cn/

Is there perhaps some explicit reason that dirty ring cannot be used?

Thanks!

-- 
Peter Xu

