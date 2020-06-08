Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1921F146C
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgFHIWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:22:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24765 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729059AbgFHIWx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 04:22:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591604571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NyMg6N0JWGe/FBViY6LX3oA9FUvdeC6zOGN/RVMyeP8=;
        b=a8dA+ZhQBqHxSr3eFVOTv0aUGz387hTJ0EFMSZQFDZMm6sH9GJNc8RN8YeibkSLcgo61CO
        v8HcW/N2AduHKR0w0mKhqW4vXME6JRfOz2nNjYRYTHOxTY359tR3rFWhuG5OdEVY0BRg9H
        d9VAB4s4KxZz36JLl5JQ8XLDROrd0wM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-zSB4kDWZN-6xxR6kfLuaAw-1; Mon, 08 Jun 2020 04:22:49 -0400
X-MC-Unique: zSB4kDWZN-6xxR6kfLuaAw-1
Received: by mail-ej1-f69.google.com with SMTP id r11so5778887ejd.1
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 01:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NyMg6N0JWGe/FBViY6LX3oA9FUvdeC6zOGN/RVMyeP8=;
        b=Jqngud4p/l4DDIz3TT1PeG1/JFaCVnTcgLrKvI20KaL88snAY7PWR+Y91/n3pL482D
         USDiVnUx9NzNzd8Bh8I/36xnHoZFMXiiKC0rNhJZvR4bR60MAnc8rACnfcZTHjpWW4if
         +cvzgZ6iS7bkVybvmFS06GWGU1PsqejtrbwR6FA0pJK21/1C1uEkd6GkJ33xFoHgd26r
         SoI1w6Wz6RO4dwxZZoeP/fsxERyCk/gHevM25XOpCJV1uoBTb6CgR2Jz7tEtVwmLBTy1
         0wipaTyzbLsnoD8CqyYszomfgNj4Ydn3ufQUbh/PM/g7h4E4lxLTUriaQ+kgPSQo8iIo
         9X8g==
X-Gm-Message-State: AOAM5329hCZh+SVmtI9tzHFwaneuLM35+THa6zFyuZn9Y/I9BbXDOcxQ
        kjqYoUMs+91OvBCGZifeAoGq6+rqycjjwDJfXFgEItXtCCEmX9P2AwI2jkuo1hAXRJvGoRyEvbn
        4aRblLtGkPu18
X-Received: by 2002:aa7:db47:: with SMTP id n7mr20758315edt.223.1591604568113;
        Mon, 08 Jun 2020 01:22:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkP7M6z3foOKnxN+p/Xf0dIo8XXvJ8w0HhHlFySzLpgRFiJ/XK6UxkPNR8QIFBYAvbJrrraQ==
X-Received: by 2002:aa7:db47:: with SMTP id n7mr20758303edt.223.1591604567886;
        Mon, 08 Jun 2020 01:22:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id fi13sm10311766ejb.34.2020.06.08.01.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 01:22:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     syzbot+705f4401d5a93a59b87d@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: let kvm_destroy_vm_debugfs clean up vCPU debugfs directories
In-Reply-To: <20200605170633.16766-1-pbonzini@redhat.com>
References: <20200605170633.16766-1-pbonzini@redhat.com>
Date:   Mon, 08 Jun 2020 10:22:45 +0200
Message-ID: <875zc2c6ga.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> After commit 63d0434 ("KVM: x86: move kvm_create_vcpu_debugfs after
> last failure point") we are creating the pre-vCPU debugfs files
> after the creation of the vCPU file descriptor.  This makes it
> possible for userspace to reach kvm_vcpu_release before
> kvm_create_vcpu_debugfs has finished.  The vcpu->debugfs_dentry
> then does not have any associated inode anymore, and this causes
> a NULL-pointer dereference in debugfs_create_file.
>
> The solution is simply to avoid removing the files; they are
> cleaned up when the VM file descriptor is closed (and that must be
> after KVM_CREATE_VCPU returns).  We can stop storing the dentry
> in struct kvm_vcpu too, because it is not needed anywhere after
> kvm_create_vcpu_debugfs returns.
>
> Reported-by: syzbot+705f4401d5a93a59b87d@syzkaller.appspotmail.com
> Fixes: 63d04348371b ("KVM: x86: move kvm_create_vcpu_debugfs after last failure point")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/arm64/kvm/arm.c     |  5 -----
>  arch/x86/kvm/debugfs.c   | 10 +++++-----
>  include/linux/kvm_host.h |  3 +--
>  virt/kvm/kvm_main.c      |  8 ++++----
>  4 files changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7a57381c05e8..45276ed50dd6 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -144,11 +144,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	return ret;
>  }
>  
> -int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
> -{
> -	return 0;
> -}
> -
>  vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
>  {
>  	return VM_FAULT_SIGBUS;
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index 018aebce33ff..7e818d64bb4d 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -43,22 +43,22 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
>  
>  DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
>  
> -void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
> +void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
>  {
> -	debugfs_create_file("tsc-offset", 0444, vcpu->debugfs_dentry, vcpu,
> +	debugfs_create_file("tsc-offset", 0444, debugfs_dentry, vcpu,
>  			    &vcpu_tsc_offset_fops);
>  
>  	if (lapic_in_kernel(vcpu))
>  		debugfs_create_file("lapic_timer_advance_ns", 0444,
> -				    vcpu->debugfs_dentry, vcpu,
> +				    debugfs_dentry, vcpu,
>  				    &vcpu_timer_advance_ns_fops);
>  
>  	if (kvm_has_tsc_control) {
>  		debugfs_create_file("tsc-scaling-ratio", 0444,
> -				    vcpu->debugfs_dentry, vcpu,
> +				    debugfs_dentry, vcpu,
>  				    &vcpu_tsc_scaling_fops);
>  		debugfs_create_file("tsc-scaling-ratio-frac-bits", 0444,
> -				    vcpu->debugfs_dentry, vcpu,
> +				    debugfs_dentry, vcpu,
>  				    &vcpu_tsc_scaling_frac_fops);
>  	}
>  }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f43b59b1294c..d38d6b9c24be 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -318,7 +318,6 @@ struct kvm_vcpu {
>  	bool preempted;
>  	bool ready;
>  	struct kvm_vcpu_arch arch;
> -	struct dentry *debugfs_dentry;
>  };
>  
>  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
> @@ -888,7 +887,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
>  
>  #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
> -void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu);
> +void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry);
>  #endif
>  
>  int kvm_arch_hardware_enable(void);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7fa1e38e1659..3577eb84eac0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2973,7 +2973,6 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
>  {
>  	struct kvm_vcpu *vcpu = filp->private_data;
>  
> -	debugfs_remove_recursive(vcpu->debugfs_dentry);
>  	kvm_put_kvm(vcpu->kvm);
>  	return 0;
>  }
> @@ -3000,16 +2999,17 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
>  static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  {
>  #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
> +	struct dentry *debugfs_dentry;
>  	char dir_name[ITOA_MAX_LEN * 2];
>  
>  	if (!debugfs_initialized())
>  		return;
>  
>  	snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
> -	vcpu->debugfs_dentry = debugfs_create_dir(dir_name,
> -						  vcpu->kvm->debugfs_dentry);
> +	debugfs_dentry = debugfs_create_dir(dir_name,
> +					    vcpu->kvm->debugfs_dentry);
>  
> -	kvm_arch_create_vcpu_debugfs(vcpu);
> +	kvm_arch_create_vcpu_debugfs(vcpu, debugfs_dentry);
>  #endif
>  }

FWIW,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly

