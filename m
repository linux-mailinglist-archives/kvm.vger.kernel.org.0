Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971FA62194F
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 17:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiKHQZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 11:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiKHQZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 11:25:52 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A19222AE
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 08:25:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so13877895pji.0
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 08:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTF7zBV9BebekratF2JVorEYVbhlKTgdQ9m8AxTWHRk=;
        b=rQzrBHKna1kMWB/FTWk17gtE5olvWShg6ghF8NLwazHqkAG98BIFOuEmDIqeZcx0Dq
         x8TI9L3ATQXwCsMqDemKLxtgDjBO6h+7iozA96wlf4afwjPbN2O7/BmSACchQ1QsBSAY
         eIxZleAKK3blkRPX68m5b61IHnX2CnofahbVYhopt+kNyHT7kfQuVhwWNAabRDMMmfhW
         t8j80v6pWp0hGYnUJ7nEDa9DOVBX2Dq74yy9NjvDuZPIxoG6MTgPKpDOvKuo2WCJg9rz
         asY7HP/PV4JhksLG2wQXKRcQ9jPcOh3uUTagyaE0gls3Uinuu0RmvyVj+HddGKugWBSj
         XtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTF7zBV9BebekratF2JVorEYVbhlKTgdQ9m8AxTWHRk=;
        b=UfMIrTOZI9x+QrUi5e/1cXLNF1DvAqfNqe6k4wubkp2yNtTycZyt1r7RuqlowXTAci
         bUj6+7DWZybPfbeccUqIs6fXghKrHv4DI+Ssa0S101smr7x3aC6imKrjb6XUO3wcbwFs
         qTfsJ11KtKqTETGSelrDjY0Fb8dX2rGfhkK3pOKU5OPPfKkSU808W3mrHERb/bRoXLO0
         H4BGRAoSWRte8DfI683Q9odnIv31Ys1wycWK0vQYFbgk0W4HUQTSnAbRUCGkRqWWdCny
         uJMzobISlq2hLir4dTRnEkswTUJPoVPOE97Vpx7MAwdpx4ZHtTltj+TKdQLilaJVPxLS
         0qxw==
X-Gm-Message-State: ACrzQf3Ge1BgOX8xGVdcErRGflpgP3ijunrn2ol5gblQdNMZEaDjQGGZ
        Br1zlC3YqMraWemiWyPSDpzOccyyQeBIwg==
X-Google-Smtp-Source: AMsMyM5ulA1kczG/5edhpphYQpzdwQVBPzle22DMXKS1AiAksaw+qNmqzhYbIHAV8riAiSrCetMPNw==
X-Received: by 2002:a17:902:8ecc:b0:188:5f4b:260e with SMTP id x12-20020a1709028ecc00b001885f4b260emr27873892plo.111.1667924750257;
        Tue, 08 Nov 2022 08:25:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ij22-20020a170902ab5600b0017f36638010sm7078822plb.276.2022.11.08.08.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 08:25:49 -0800 (PST)
Date:   Tue, 8 Nov 2022 16:25:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        oliver.upton@linux.dev, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v9 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2qDCqFeL1vwqq3f@google.com>
References: <20221108041039.111145-1-gshan@redhat.com>
 <20221108041039.111145-4-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108041039.111145-4-gshan@redhat.com>
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

On Tue, Nov 08, 2022, Gavin Shan wrote:
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 800f9470e36b..228be1145cf3 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -33,6 +33,14 @@ config HAVE_KVM_DIRTY_RING_ACQ_REL
>         bool
>         select HAVE_KVM_DIRTY_RING
>  
> +# Only architectures that need to dirty memory outside of a vCPU
> +# context should select this, advertising to userspace the
> +# requirement to use a dirty bitmap in addition to the vCPU dirty
> +# ring.

The Kconfig does more than advertise a feature to userspace.

 # Allow enabling both the dirty bitmap and dirty ring.  Only architectures that
 # need to dirty memory outside of a vCPU context should select this.

> +config HAVE_KVM_DIRTY_RING_WITH_BITMAP

I think we should replace "HAVE" with "NEED".  Any architecture that supports the
dirty ring can easily support ring+bitmap, but based on the discussion from v5[*],
the comment above, and the fact that the bitmap will _never_ be used in the
proposed implementation because x86 will always have a vCPU, this Kconfig should
only be selected if the bitmap is needed to support migration.

[*] https://lore.kernel.org/all/Y0SxnoT5u7+1TCT+@google.com

> +	bool
> +	depends on HAVE_KVM_DIRTY_RING
> +
>  config HAVE_KVM_EVENTFD
>         bool
>         select EVENTFD
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index fecbb7d75ad2..f95cbcdd74ff 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -21,6 +21,18 @@ u32 kvm_dirty_ring_get_rsvd_entries(void)
>  	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
>  }
>  
> +bool kvm_use_dirty_bitmap(struct kvm *kvm)
> +{
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
> +}
> +
> +bool __weak kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)

Rather than __weak, what about wrapping this with an #ifdef to effectively force
architectures to implement the override if they need ring+bitmap?  Given that the
bitmap will never be used if there's a running vCPU, selecting the Kconfig without
overriding this utility can't possibly be correct.

  #ifndef CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP
  bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
  {
	return false;
  }
  #endif

> @@ -4588,6 +4608,29 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  			return -EINVAL;
>  
>  		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
> +		int r = -EINVAL;
> +
> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> +		    !kvm->dirty_ring_size)

I have no objection to disallowing userspace from disabling the combo, but I
think it's worth requiring cap->args[0] to be '0' just in case we change our minds
in the future.

> +			return r;
> +
> +		mutex_lock(&kvm->slots_lock);
> +
> +		/*
> +		 * For simplicity, allow enabling ring+bitmap if and only if
> +		 * there are no memslots, e.g. to ensure all memslots allocate
> +		 * a bitmap after the capability is enabled.
> +		 */
> +		if (kvm_are_all_memslots_empty(kvm)) {
> +			kvm->dirty_ring_with_bitmap = true;
> +			r = 0;
> +		}
> +
> +		mutex_unlock(&kvm->slots_lock);
> +
> +		return r;
> +	}
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> -- 
> 2.23.0
> 
