Return-Path: <kvm+bounces-23154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8172894650B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 23:28:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E66E9B226AE
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 21:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C5712E1D1;
	Fri,  2 Aug 2024 21:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QfKsl9RJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B54F77102
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 21:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722634090; cv=none; b=sxkvuNNQ7l8V2yMMsI9Z8lHdV2x7EXbBrdf0JlC06vQjZLy6yQ9W/YUx4/DANUlnGVb76eisbSCQO2ug4a49MbXBeKtN9SnIL7EDmSC7n7idrXvF6ij0vo0icMcAfbyeDGq89BG972z1uC/ClLex+7W4knpqq3SXmdNJO8wXmNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722634090; c=relaxed/simple;
	bh=Hb5RGJ725IkNLDCGb6BC/OYAZbPAGXAI7qMNSv6Tkxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIL8v0eXYxhYpxvBLnhokAegIlxJDpp+ool2Bfei+Yz4U/LztvBvVTt2ipQWphn37h+R5W+edKmH3qrW4DB5yht5qDO8CW2WfC6GvCuXzcmhy2hkzMcrG25UmndptjW08yiM5bpAu+xEk2fxo4hod8e+iMcjKrXxhPUaoHjjn6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QfKsl9RJ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-428e12f6e56so165365e9.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 14:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722634087; x=1723238887; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnigBMu/xWPcjnITDfnjOcwLt//WI1Lvv6cQExwM4m4=;
        b=QfKsl9RJ1NhkyZXm6w9MXBon1LK1TGiA8ouZ7Ht+SO25JJlGt3rA1FCwjAmchiAIH9
         uZxWoGGnsNMorAcP1BKVDJjnsGOX829VrEq70IW6VWT4bX9bSCPlpgDfLkYYVU/w5D78
         TEiM1zkeD7WVofnMS/buIDDFKDsmwjE6XQ4fVl9Zy3qPxID0lcyULPXFJlTp1K7yKhA3
         0SVxJ0Vx1dwt05gwqQg9DRJWGy1N2JKJboboErVAfbxBKKnxbKO4mknvxS2cZQYmYg3k
         9eVCc8ApJINi9EpV4Y9nS3R8TPCC63GN54XIh5alTKOgm0sMIUnCgMwwI6GSEBIPttpJ
         loIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722634087; x=1723238887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnigBMu/xWPcjnITDfnjOcwLt//WI1Lvv6cQExwM4m4=;
        b=lLwBSQOKeGFZ4lChodgNh1DFJTAJmW9l5VSgWgbbVwtkLD0+OWCP7brgGqJ+SbAWRy
         Esht3gsYS/I92zlVLhEHmiYu1yKpF8ed2s3zx2qpc/TmBGQzUhGkFKBdC1qWWgo8zu5z
         8T8BlKH1D1VO0DLY3UcAfZRL4bhETrFpV9bp5ojArgqz3fjkduBeRgT1acoyTaAdvj9n
         xptpvFx5atTwybJbmQpYOHDaKuzt+5C9sUaU55rHbL6nxLs5p2LDzntuEthIZ64QDdrI
         hN8bcSRjLo7iLMkv1ryiEvLz0OtWRWP+wWY6sSqdTWr3mR8lzlUr7kp59Y6smHTdq6vj
         Khcw==
X-Forwarded-Encrypted: i=1; AJvYcCUyAuqGNnNn75u4RmjY43J53KAl+E2H3K3IA1ACkPOMBvPNLfUFTMUAkqySXukdh7o8QcglDYOCvlGu5kUFOVEa2CO2
X-Gm-Message-State: AOJu0YwKn1G9vIjyeCzBi0UeyKg5zF6hFH1ye92wX5vsLpLL9oakAMBn
	n3VMKDzu9nxyPi4yKHS3Tu4pUoqcvxly6GxOAKRwqXHsImGaEz8vQaRkL3VdWb8dcc5YFjMSOvJ
	evswf4/s9SwAyh9Ai41qiFHbqsAAPxF3Wsmpd
X-Google-Smtp-Source: AGHT+IEy0/ExLs2GCA1i58dsZtt/NIgPBvlCOWYfeCAs5ZR2WL7dwgp15gX0w+DpzgpvBN8/PXqcYv3LgOsqEJPu2SQ=
X-Received: by 2002:a05:600c:c8d:b0:426:5ef2:cd97 with SMTP id
 5b1f17b1804b1-428ef474defmr119025e9.2.1722634085870; Fri, 02 Aug 2024
 14:28:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com> <20240802200136.329973-3-seanjc@google.com>
In-Reply-To: <20240802200136.329973-3-seanjc@google.com>
From: Steve Rutherford <srutherford@google.com>
Date: Fri, 2 Aug 2024 14:27:29 -0700
Message-ID: <CABayD+cWH47Ort22iiUcb17-k2Q+54Mh0xooC64rThLOR08Eew@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 2, 2024 at 1:01=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> To avoid jitter on KVM_RUN due to synchronize_rcu(), use a rwlock instead
> of RCU to protect vcpu->pid, a.k.a. the pid of the task last used to a
> vCPU.  When userspace is doing M:N scheduling of tasks to vCPUs, e.g. to
> run SEV migration helper vCPUs during post-copy, the synchronize_rcu()
> needed to change the PID associated with the vCPU can stall for hundreds
> of milliseconds, which is problematic for latency sensitive post-copy
> operations.
>
> In the directed yield path, do not acquire the lock if it's contended,
> i.e. if the associated PID is changing, as that means the vCPU's task is
> already running.
>
> Reported-by: Steve Rutherford <srutherford@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  include/linux/kvm_host.h          |  3 ++-
>  virt/kvm/kvm_main.c               | 32 +++++++++++++++++--------------
>  3 files changed, 21 insertions(+), 16 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index a33f5996ca9f..7199cb014806 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1115,7 +1115,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu=
,
>  void kvm_arm_halt_guest(struct kvm *kvm);
>  void kvm_arm_resume_guest(struct kvm *kvm);
>
> -#define vcpu_has_run_once(vcpu)        !!rcu_access_pointer((vcpu)->pid)
> +#define vcpu_has_run_once(vcpu)        (!!READ_ONCE((vcpu)->pid))
>
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  #define kvm_call_hyp_nvhe(f, ...)                                       =
       \
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 689e8be873a7..d6f4e8b2b44c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -342,7 +342,8 @@ struct kvm_vcpu {
>  #ifndef __KVM_HAVE_ARCH_WQP
>         struct rcuwait wait;
>  #endif
> -       struct pid __rcu *pid;
> +       struct pid *pid;
> +       rwlock_t pid_lock;
>         int sigset_active;
>         sigset_t sigset;
>         unsigned int halt_poll_ns;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 91048a7ad3be..fabffd85fa34 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -486,6 +486,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, stru=
ct kvm *kvm, unsigned id)
>         vcpu->kvm =3D kvm;
>         vcpu->vcpu_id =3D id;
>         vcpu->pid =3D NULL;
> +       rwlock_init(&vcpu->pid_lock);
>  #ifndef __KVM_HAVE_ARCH_WQP
>         rcuwait_init(&vcpu->wait);
>  #endif
> @@ -513,7 +514,7 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
>          * the vcpu->pid pointer, and at destruction time all file descri=
ptors
>          * are already gone.
>          */
> -       put_pid(rcu_dereference_protected(vcpu->pid, 1));
> +       put_pid(vcpu->pid);
>
>         free_page((unsigned long)vcpu->run);
>         kmem_cache_free(kvm_vcpu_cache, vcpu);
> @@ -3930,15 +3931,17 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
>
>  int kvm_vcpu_yield_to(struct kvm_vcpu *target)
>  {
> -       struct pid *pid;
>         struct task_struct *task =3D NULL;
>         int ret;
>
> -       rcu_read_lock();
> -       pid =3D rcu_dereference(target->pid);
> -       if (pid)
> -               task =3D get_pid_task(pid, PIDTYPE_PID);
> -       rcu_read_unlock();
> +       if (!read_trylock(&target->pid_lock))
> +               return 0;
> +
> +       if (target->pid)
> +               task =3D get_pid_task(target->pid, PIDTYPE_PID);
> +
> +       read_unlock(&target->pid_lock);
> +
>         if (!task)
>                 return 0;
>         ret =3D yield_to(task, 1);
> @@ -4178,9 +4181,9 @@ static int vcpu_get_pid(void *data, u64 *val)
>  {
>         struct kvm_vcpu *vcpu =3D data;
>
> -       rcu_read_lock();
> -       *val =3D pid_nr(rcu_dereference(vcpu->pid));
> -       rcu_read_unlock();
> +       read_lock(&vcpu->pid_lock);
> +       *val =3D pid_nr(vcpu->pid);
> +       read_unlock(&vcpu->pid_lock);
>         return 0;
>  }
>
> @@ -4466,7 +4469,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                 r =3D -EINVAL;
>                 if (arg)
>                         goto out;
> -               oldpid =3D rcu_access_pointer(vcpu->pid);
> +               oldpid =3D vcpu->pid;
>                 if (unlikely(oldpid !=3D task_pid(current))) {
>                         /* The thread running this VCPU changed. */
>                         struct pid *newpid;
> @@ -4476,9 +4479,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                                 break;
>
>                         newpid =3D get_task_pid(current, PIDTYPE_PID);
> -                       rcu_assign_pointer(vcpu->pid, newpid);
> -                       if (oldpid)
> -                               synchronize_rcu();
> +                       write_lock(&vcpu->pid_lock);
> +                       vcpu->pid =3D newpid;
> +                       write_unlock(&vcpu->pid_lock);
> +
>                         put_pid(oldpid);
>                 }
>                 vcpu->wants_to_run =3D !READ_ONCE(vcpu->run->immediate_ex=
it__unsafe);
> --
> 2.46.0.rc2.264.g509ed76dc8-goog
>
Reviewed-by: Steve Rutherford <srutherford@google.com>

