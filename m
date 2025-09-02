Return-Path: <kvm+bounces-56611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FE52B409F9
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D599B543A3E
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 15:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89E8334361;
	Tue,  2 Sep 2025 15:58:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE0F32ED54
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756828726; cv=none; b=XlXQbHiPXXpTHPHSeMum/MiFrhsXLCd7BafNBdwX75/o7tx7k0gHVwq/U4ZeMkGdWbeJYJ9gJ75/2A3U33s89m2BA6CD9jJiXxomT99dSI9uifKF97IMmewtOcQi2ihwylX5ZO5HHgFefi7pz6/IlQ0gGZKuhuhqoHXIzs8CyyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756828726; c=relaxed/simple;
	bh=TH8J55jkMGRrCAa5Mkr1Y99DTRNxsh7OU3A1JPGeguE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhoCXfzpp4C/z8HZmMpuIJ5FcwqjVY/HDY6LOuQFUGAnwvnNeIZwl7oXC3Fy/Sotn7p9CMcoBPXjMiI6oonBAz/AYqZDgP4Bxt9DpS7/+0VlKxGBjKW3bjj4oaCVqewF46+PrK+68JQ1wqDxjdoDPOQGRgsAz6J63BKj3j3mml0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1BEA1595;
	Tue,  2 Sep 2025 08:58:34 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2DAA63F6A8;
	Tue,  2 Sep 2025 08:58:42 -0700 (PDT)
Date: Tue, 2 Sep 2025 16:58:18 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Ted Chen <znscnchen@gmail.com>
Cc: Ben Horgan <ben.horgan@arm.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Avoid debugfs warning caused by repeated vm fd
 number
Message-ID: <aLcUGm3HcU39q2gp@e133380.arm.com>
References: <20250901130336.112842-1-znscnchen@gmail.com>
 <b227a304-9b2f-4e89-9ca5-41d836ae4bae@arm.com>
 <aLbnOUXUq7fbF6Mv@t-chicago-u-2404>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLbnOUXUq7fbF6Mv@t-chicago-u-2404>

Hi,

On Tue, Sep 02, 2025 at 08:46:49PM +0800, Ted Chen wrote:
> On Mon, Sep 01, 2025 at 02:39:06PM +0100, Ben Horgan wrote:
> > Hi Ted,
> > 
> > On 9/1/25 14:03, Ted Chen wrote:
> > > Avoid debugfs warning like "KVM: debugfs: duplicate directory 59904-4"
> > > caused by creating VMs with the same vm fd number in a single process.
> > > 
> > > As shown in the below test case, two test() are executed sequentially in a
> > > single process, each creating a new VM.
> > > 
> > > Though the 2nd test() creates a new VM after the 1st test() closes the
> > > vm_fd, KVM prints warnings like "KVM: debugfs: duplicate directory 59904-4"
> > > on creating the 2nd VM.
> > > 
> > > This is due to the dup() of the vcpu_fd in test(). So, after closing the
> > > 1st vm_fd, kvm->users_count of the 1st VM is still > 0 when creating the
> > > 2nd VM. So, KVM has not yet invoked kvm_destroy_vm() and
> > > kvm_destroy_vm_debugfs() for the 1st VM after closing the 1st vm_fd. The
> > > 2nd test() thus will be able to create a different VM with the same vm fd
> > > number as the 1st VM.
> > > 
> > > Therefore, besides having "pid" and "fdname" in the dir_name of the
> > > debugfs, add a random number to differentiate different VMs to avoid
> > > printing warning, also allowing the 2nd VM to have a functional debugfs.
> > > 
> > > Use get_random_u32() to avoid dir_name() taking up too much memory while
> > > greatly reducing the chance of printing warning.
> > > 
> > > void test(void)
> > > {
> > >         int kvm_fd, vm_fd, vcpu_fd;
> > > 
> > >         kvm_fd = open("/dev/kvm", O_RDWR);
> > >         if (kvm_fd == -1)
> > >                 return;
> > > 
> > >         vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
> > >         if (vm_fd == -1)
> > >                 return;
> > >         vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> > >         if (vcpu_fd == -1)
> > >                 return;
> > > 
> > >         dup(vcpu_fd);
> > >         close(vcpu_fd);
> > >         close(vm_fd);
> > >         close(kvm_fd);
> > > }
> > > 
> > > int main()
> > > {
> > >         test();
> > >         test();
> > > 
> > >         return 0;
> > > }
> > > 
> > > Signed-off-by: Ted Chen <znscnchen@gmail.com>
> > > ---
> > >  virt/kvm/kvm_main.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 6c07dd423458..f92a60ed5de8 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -1017,7 +1017,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
> > >  {
> > >  	static DEFINE_MUTEX(kvm_debugfs_lock);
> > >  	struct dentry *dent;
> > > -	char dir_name[ITOA_MAX_LEN * 2];
> > > +	char dir_name[ITOA_MAX_LEN * 3];
> > >  	struct kvm_stat_data *stat_data;
> > >  	const struct _kvm_stats_desc *pdesc;
> > >  	int i, ret = -ENOMEM;
> > > @@ -1027,7 +1027,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
> > >  	if (!debugfs_initialized())
> > >  		return 0;
> > >  
> > > -	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
> > > +	snprintf(dir_name, sizeof(dir_name), "%d-%s-%u", task_pid_nr(current),
> > > +		 fdname, get_random_u32());
> > 
> > This does make the directory names (very likely) to be unique but it's
> > not helpful in distinguishing which directory maps to which vm. I wonder
> > if there is some better id we could use here.
> Good point. Maybe use timestamp instead?
> So, we can know a bigger timestamp value corresponds to a VM created later.
> Also since VMs are created in a single thread, they can't have the same

Why must all VMs be created in a single thread?

> timestamp value.
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6c07dd423458..c3b0880be79a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1017,7 +1017,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
>  {
>         static DEFINE_MUTEX(kvm_debugfs_lock);
>         struct dentry *dent;
> -       char dir_name[ITOA_MAX_LEN * 2];
> +       char dir_name[ITOA_MAX_LEN * 4];

Hmmm.

>         struct kvm_stat_data *stat_data;
>         const struct _kvm_stats_desc *pdesc;
>         int i, ret = -ENOMEM;
> @@ -1027,7 +1027,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
>         if (!debugfs_initialized())
>                 return 0;
> 
> -       snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
> +       snprintf(dir_name, sizeof(dir_name), "%d-%s-%llx", task_pid_nr(current),
> +                fdname, ktime_get_ns());
>         mutex_lock(&kvm_debugfs_lock);
>         dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
>         if (dent) {
> 
> 
> > Should the vm stats_id also be updated to be unique and use the same scheme?
>
> I don't think so. Unlike debugfs paths that will be accessed directly by
> userspace, the stats_id is used by anonymous inode files openned with unique
> fd numbers in a single process. So, duplicated names should be ok.

Just sticking my oar in here, since I'm interested in how we identify
VMs and vCPUs for use by other kernel subsystems:

The two proposed approaches may not guarantee uniqueness.  The PID is
not unique because a single process can create multiple VMs.  Possibly,
VMs can outlive the PID of the creating process (if a KVM fd is passed
to another process, and the original process terminates).  The fd is
not unique because fds can be moved around with dup() and reallocated.
Random numbers are not unique (only _probably_ unique.)

If VMs are created from two threads simultaneously and if ownership of
kvm_debugfs_lock can move fast enough, or there is enough skid or
imprecision in the timestamp, then can ktime_get_ns() be non-unique too?

_Maybe_ this is good enough for debugfs -- which is often treated in a
best-effort way by kernel code.
 

However, if we really want a robust ID that can not only distinguish
between VMs but can also tell us reliably (and usefully) which is which
even when multiple VMs are created by a single process, I think KVM
userspace needs to be able to set and/or retrieve the ID, or part of it.

It might make sense to define a new kind of identifier for such
purposes.

I'm guessing that this is out of the scope for this patch, though.

Cheers
---Dave

