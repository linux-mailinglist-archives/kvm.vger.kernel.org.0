Return-Path: <kvm+bounces-56975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AADEB48E82
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 15:02:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39C01188704C
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 13:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E10E3081A1;
	Mon,  8 Sep 2025 13:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGsKID9X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC9E2FF657
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 13:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757336568; cv=none; b=JGaWS7n33VBNxbqwSes2SAX5RJExLeC4ejsVXbPnVm7QFu4tGYTbEkIEmUfVEaVyZNUXIksWqTPf/HrndzQCprOpLhndhtnhnHH1FoyPOg5RdDO96chtdHAjeJTBV4drp7wj2/KtfexhlbLXxps/jZuGLRr6zTeEPIWIAyfwGOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757336568; c=relaxed/simple;
	bh=+JreuUwhzJ0RPCwLVRN+u/0EQ2f/982qQTQn0rO0/Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4xIhNBgi4IR0qDA1ywNJUkV/n/Hp9CwDhgsY/8IIiBtaKFwEgvA6w/A906S7dnaWjkTiZmsMSvkJDsSZvYJSDTeRbD3lgv9NJjkeJxoD2gqDNNIO+alhXCW9BGv26h60JLWUyoTwNXt7LfuBR4WsIscOSyvmC5FW8RG7jjvxhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PGsKID9X; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-724b9ba77d5so46025137b3.3
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 06:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757336566; x=1757941366; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PnaJYM8o+bNZjQrfX5qfOUjpVL9bEtu2ZIamOA9HfJE=;
        b=PGsKID9XotFTXeWNkO/xhArYXh5COKnieJiEh/+pRlK5AdO055fhYxMBpCfl96mAmW
         pLSa1fwONxa+FtXLhbI+rdeumdp2XU+qxxoei5cRH3vo77c4XEuVZ3bnyXPY1We6WwuC
         Z+O4xAYfKDQRNp9CCPr6htol617ZLo4sYZHldM9lG9j68KJCDP99a22T89GZk+8zj0BI
         raZa0pMro7SpGWSpcsd0qShsVh66UDCf597b4POPEP0CSaZhrrcWtyKG4ruYQFIU0aX5
         FULSgX2eA1BH/a7HYe9B3Y11pQ1ADHHQmuD14lSqO8pZB+hOLxCc1cgVxSHJ6CwmsVtR
         0Izg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757336566; x=1757941366;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnaJYM8o+bNZjQrfX5qfOUjpVL9bEtu2ZIamOA9HfJE=;
        b=RJgLFQVsCyxo5vfjl1G699LacrY4LCltfScvbDNCX+aQMeVX0j1LgV97IMcI9CbBRx
         xfmeN+1j/BKus2Xhb2hCW+phV95f+sJwzFe070EYuUJsRqcMvoKLypbVhRmhs4uZyHWu
         DDKHOcXSxoUArx0PGYBzwZTwlCORfzyAzTSsFZnxpTeXAfBprl6egYQXqlHVF361oKGw
         /oRLMWOBgCQHlhDp/EaP7D9thuJ22cw/AOfhLiUYn4LbjwTctUehsz497tJdDkrwDvc0
         V3aoRVTNn0pairocEBCWdOHRsncf6bjC/9cPWvEJs76vpRngKUx5iSx6PzePS5PUC/hD
         G0vA==
X-Forwarded-Encrypted: i=1; AJvYcCWAI6xWRIGLUqAW5fN5FWGjI/w8pPOYrJ+VizBe003HOBTOuMqw/Kx6UjRoQDRmySMy348=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfxlRpi0mv2W8kTK8DY1SzdkpeYGv7RdVW4obr4PkfZlvtxN7e
	rXRe6z3p5uIuGtuoUJ4sm5pPLZKpvNE5PDZzgclV7Ax8V6t2gXg9WU8=
X-Gm-Gg: ASbGncs8E57eDM8fzfdLi6osBabq9UOhcwl0NNSJu5mwOWo1YTZRrT7TCCl7XhrrI/D
	2omyba4A2uJlNhP8NJdw9XBB9W55xc5LUHKgK44PUoYLi9+70TL0M84N5HFRo2ej0z2Ks6wZEiS
	InAM3c8rVdbu4XyzMTZpy8rWXM7By4P2FO0RuFunGdWK+lqAMH2rpdTVQERe4MEvipkTToJalSy
	qwHvMaha1Uf/PH9nV2lGRfUzj03JEGdRZUb7RB+uT4SVZARcT60Y91BT8+z+vgH1DqH7mwxx5s3
	qkR2PKYxD3lmAbmCffhJZzZgrqqE3777/Lc4MSXAavgoX0/rIuUg/FLUTKE1OLFqRIFPoygSuq8
	7juXlNuRvnNNaVrh1RGG1MQfNhe0ozw1g4sxZt52XZx0Q4EdCOPAw
X-Google-Smtp-Source: AGHT+IH3Y5Q/tuSb5yRjqdwtBfa9u1u8dwWJ5vPAEO/WdjT9i8cCuZ1M+GPWGkMyGLrmnb3YdTIA/g==
X-Received: by 2002:a53:a6c7:0:b0:612:5a11:387f with SMTP id 956f58d0204a3-6125a113915mr4313127d50.34.1757336564375;
        Mon, 08 Sep 2025 06:02:44 -0700 (PDT)
Received: from t-chicago-u-2404 ([2001:19f0:5c00:2be4:5400:5ff:fe7e:238d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720add66632sm122536796d6.32.2025.09.08.06.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 06:02:43 -0700 (PDT)
Date: Mon, 8 Sep 2025 21:02:41 +0800
From: Ted Chen <znscnchen@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Ben Horgan <ben.horgan@arm.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: Avoid debugfs warning caused by repeated vm fd
 number
Message-ID: <aL7T8R25Rr3ALr2H@t-chicago-u-2404>
References: <20250901130336.112842-1-znscnchen@gmail.com>
 <b227a304-9b2f-4e89-9ca5-41d836ae4bae@arm.com>
 <aLbnOUXUq7fbF6Mv@t-chicago-u-2404>
 <aLcUGm3HcU39q2gp@e133380.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLcUGm3HcU39q2gp@e133380.arm.com>

On Tue, Sep 02, 2025 at 04:58:18PM +0100, Dave Martin wrote:
> Hi,
> 
> On Tue, Sep 02, 2025 at 08:46:49PM +0800, Ted Chen wrote:
> > On Mon, Sep 01, 2025 at 02:39:06PM +0100, Ben Horgan wrote:
> > > Hi Ted,
> > > 
> > > On 9/1/25 14:03, Ted Chen wrote:
> > > > Avoid debugfs warning like "KVM: debugfs: duplicate directory 59904-4"
> > > > caused by creating VMs with the same vm fd number in a single process.
> > > > 
> > > > As shown in the below test case, two test() are executed sequentially in a
> > > > single process, each creating a new VM.
> > > > 
> > > > Though the 2nd test() creates a new VM after the 1st test() closes the
> > > > vm_fd, KVM prints warnings like "KVM: debugfs: duplicate directory 59904-4"
> > > > on creating the 2nd VM.
> > > > 
> > > > This is due to the dup() of the vcpu_fd in test(). So, after closing the
> > > > 1st vm_fd, kvm->users_count of the 1st VM is still > 0 when creating the
> > > > 2nd VM. So, KVM has not yet invoked kvm_destroy_vm() and
> > > > kvm_destroy_vm_debugfs() for the 1st VM after closing the 1st vm_fd. The
> > > > 2nd test() thus will be able to create a different VM with the same vm fd
> > > > number as the 1st VM.
> > > > 
> > > > Therefore, besides having "pid" and "fdname" in the dir_name of the
> > > > debugfs, add a random number to differentiate different VMs to avoid
> > > > printing warning, also allowing the 2nd VM to have a functional debugfs.
> > > > 
> > > > Use get_random_u32() to avoid dir_name() taking up too much memory while
> > > > greatly reducing the chance of printing warning.
> > > > 
> > > > void test(void)
> > > > {
> > > >         int kvm_fd, vm_fd, vcpu_fd;
> > > > 
> > > >         kvm_fd = open("/dev/kvm", O_RDWR);
> > > >         if (kvm_fd == -1)
> > > >                 return;
> > > > 
> > > >         vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
> > > >         if (vm_fd == -1)
> > > >                 return;
> > > >         vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> > > >         if (vcpu_fd == -1)
> > > >                 return;
> > > > 
> > > >         dup(vcpu_fd);
> > > >         close(vcpu_fd);
> > > >         close(vm_fd);
> > > >         close(kvm_fd);
> > > > }
> > > > 
> > > > int main()
> > > > {
> > > >         test();
> > > >         test();
> > > > 
> > > >         return 0;
> > > > }
> > > > 
> > > > Signed-off-by: Ted Chen <znscnchen@gmail.com>
> > > > ---
> > > >  virt/kvm/kvm_main.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index 6c07dd423458..f92a60ed5de8 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -1017,7 +1017,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
> > > >  {
> > > >  	static DEFINE_MUTEX(kvm_debugfs_lock);
> > > >  	struct dentry *dent;
> > > > -	char dir_name[ITOA_MAX_LEN * 2];
> > > > +	char dir_name[ITOA_MAX_LEN * 3];
> > > >  	struct kvm_stat_data *stat_data;
> > > >  	const struct _kvm_stats_desc *pdesc;
> > > >  	int i, ret = -ENOMEM;
> > > > @@ -1027,7 +1027,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
> > > >  	if (!debugfs_initialized())
> > > >  		return 0;
> > > >  
> > > > -	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
> > > > +	snprintf(dir_name, sizeof(dir_name), "%d-%s-%u", task_pid_nr(current),
> > > > +		 fdname, get_random_u32());
> > > 
> > > This does make the directory names (very likely) to be unique but it's
> > > not helpful in distinguishing which directory maps to which vm. I wonder
> > > if there is some better id we could use here.
> > Good point. Maybe use timestamp instead?
> > So, we can know a bigger timestamp value corresponds to a VM created later.
> > Also since VMs are created in a single thread, they can't have the same
> 
> Why must all VMs be created in a single thread?
I happened to encounter this warning when I wrote a testcase which runs
in a single process but needs to create several VMs sequentially for
testing various cases.

> > timestamp value.
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 6c07dd423458..c3b0880be79a 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1017,7 +1017,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
> >  {
> >         static DEFINE_MUTEX(kvm_debugfs_lock);
> >         struct dentry *dent;
> > -       char dir_name[ITOA_MAX_LEN * 2];
> > +       char dir_name[ITOA_MAX_LEN * 4];
> 
> Hmmm.
> 
> >         struct kvm_stat_data *stat_data;
> >         const struct _kvm_stats_desc *pdesc;
> >         int i, ret = -ENOMEM;
> > @@ -1027,7 +1027,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
> >         if (!debugfs_initialized())
> >                 return 0;
> > 
> > -       snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
> > +       snprintf(dir_name, sizeof(dir_name), "%d-%s-%llx", task_pid_nr(current),
> > +                fdname, ktime_get_ns());
> >         mutex_lock(&kvm_debugfs_lock);
> >         dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
> >         if (dent) {
> > 
> > 
> > > Should the vm stats_id also be updated to be unique and use the same scheme?
> >
> > I don't think so. Unlike debugfs paths that will be accessed directly by
> > userspace, the stats_id is used by anonymous inode files openned with unique
> > fd numbers in a single process. So, duplicated names should be ok.
> 
> Just sticking my oar in here, since I'm interested in how we identify
> VMs and vCPUs for use by other kernel subsystems:
> 
> The two proposed approaches may not guarantee uniqueness.  The PID is
> not unique because a single process can create multiple VMs.  Possibly,
> VMs can outlive the PID of the creating process (if a KVM fd is passed
> to another process, and the original process terminates).  The fd is
> not unique because fds can be moved around with dup() and reallocated.
> Random numbers are not unique (only _probably_ unique.)
> 
> If VMs are created from two threads simultaneously and if ownership of
> kvm_debugfs_lock can move fast enough, or there is enough skid or
> imprecision in the timestamp, then can ktime_get_ns() be non-unique too?
I don't find a way of having 2 VMs to the same
"PID + fd number + ktime_get_ns()".

Could you elaborate if you think it's possible？

> _Maybe_ this is good enough for debugfs -- which is often treated in a
> best-effort way by kernel code.
Right, so I tried to make it unique while keeping least effort to KVM.

> However, if we really want a robust ID that can not only distinguish
> between VMs but can also tell us reliably (and usefully) which is which
> even when multiple VMs are created by a single process, I think KVM
> userspace needs to be able to set and/or retrieve the ID, or part of it.
>
> It might make sense to define a new kind of identifier for such
> purposes.
Hmm, it may not be worthwhile in my scenario.

> I'm guessing that this is out of the scope for this patch, though.
> 
> Cheers
> ---Dave

