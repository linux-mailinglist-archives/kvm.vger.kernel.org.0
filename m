Return-Path: <kvm+bounces-56595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C12D5B40122
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 14:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6C4F1B2857C
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 12:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602CF2D4801;
	Tue,  2 Sep 2025 12:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FReLNGCr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D1E29E10B
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 12:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756817214; cv=none; b=ZxUQQVl2/8bVHQDsk12PVLtQesqlcFL2Xw8MPvC1qtsmzF3eLKs9O2SCevyLe7tS6hxSzUZKHxpkZOfMOUhU3T71uWfoQfotaKiagZTUkaqnHg8kreuw38mpBpcgG0F1BRd1yWcCEMJmYJpwO3Cy1s9axwhfqlywbf2yQiK4mTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756817214; c=relaxed/simple;
	bh=VJ9wE9w83mCrpTiZU+QjwsE3lEmyZMRcTweyI7vwbdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CifAT7ZhadtAhO1JVD17VAhzjdspcby3OExVuivJRP4VIVXIHuDlpFmq96JTdyK6R2XYeRWHyCFEpLaF6QAtWEyQ5i/Nl7wAF+lziTSRTXdFicVYALBEjt6+E31CTG38kPmg0RE/fQO32PIe62u5fDMYgiTy0d8oCMjLH3D/5oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FReLNGCr; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3ea8b3a64beso23814395ab.0
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 05:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756817212; x=1757422012; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uz3vnu4yreVV+jS7xnnnmRj94u2D+Xc1tGDMJT47q/g=;
        b=FReLNGCrmrko+uVj8yJ8iSFZFk70+rqP1bjUsUVRvPVF28vUaVCXURIsB7Beu4vG7W
         1VCXW9Bq5s3ZhJaksXXF+xHh8zACM9kOWLYGQiN92SSGMPYmr4m24zVlqHrOiLuFPy1B
         IdaBAoTa32iJvBr2KtIX+pQUfxwaTElvKfRqRCDcmDaPJ95shQQQShzJDzldzIXZ71uy
         spmOeceA9kOrbGDXPn26vp1CrzdnIJywt8Kk9fD1Q2Z8JPG3vg1vh4WpsHT9+xRzNiNf
         e7ND/sVv8QJfrcKMAcolEyzBXqbR2mSDaI4C3PrLVzII1YTnEhVhyXK2VA7CNtLuQAJ6
         NHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756817212; x=1757422012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uz3vnu4yreVV+jS7xnnnmRj94u2D+Xc1tGDMJT47q/g=;
        b=a7FBqZ019tBS401eMaPW4gKwHEdAtS57tfop92KbSIQyEprlXTwCc11cGWw8hnxFoZ
         EiN5LJsNkW0bRpeZwyrzzRP/2om6A6J7IbZys0IfpbS+ExrCMeZIZ1TrMfjJFoBtPABw
         iuKBZoGaV9ve833kHQy6go1VOom2j6AarWJQmALvKTc+uEFthdWiQqyGh3XlWTs71h7G
         QS7DL0bdZrYCvfyg0wMYJv8elNi5lrxDI5386NmySsotZewERgfGTpdznzma0BfX2TXm
         BsvQ4CrM6T0um3jhCliwBwLGUZ1chadeshBL3IzthCrEqrTW69zgU9OmmYELgKIVfiEO
         Fkig==
X-Forwarded-Encrypted: i=1; AJvYcCW2dqDZrBZG2KWi6TBS6X0cGENUn+07ZEFkMCMJJty+2fywH7U2GLQAAoUALMAWSob3RW0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOqQ8R1TrRA9sX4o3mbHS3Cgewn40FYypNFUW4W5Enrg6UoTMn
	rTUHshEmeHybrANdVoYkQKJZWTDU8DJZyrqjzf+nLNjGyXyn3suNZWuRb60m
X-Gm-Gg: ASbGncvWtDDZBrr6SYqSPwpQivWZrjbLEoFD0jq3ytHReJEgVkJsTkB4XQI9BfFfPMe
	+txEQbJNEcnhJL3de+ZvEUha3vBiDpTqRwWEVyclqJHz3An+ZVIqcibZGKMcdRgq0dwdNLNN1dw
	39ZScoq4PGbGIRNtA8U7aed0zCe/Cr+9px3Bn7wgY4lveP0y/lmBdW1dViaZ6dtB+ofqV3mrGL1
	PZaOP+wmiDh4BxB3vqDXz9zZoA58GU5kicGj5nbi1lanQDxyQTHqnAmbazj00jPLAznAkutjDDu
	X0wF4EuQLBqAYp+Ud/bIyyZvGb5akKkgeZFW0DvO7d6d+6IoB4ffU7AxI9Sm7XlYcF0Nm/LjMOK
	7bEja1r4OaM/yKx6mFF5vxKwGkLgoRBLY9pIcusV4ug==
X-Google-Smtp-Source: AGHT+IEAqZaGrBgMcKCI/uNokA1dfCCO09GGKcSsSPM3jx8JDMiuDI+FKjsk+uz3AUySvWKKDtMJ6g==
X-Received: by 2002:a05:6e02:1a62:b0:3ec:9acc:c86c with SMTP id e9e14a558f8ab-3f401aee3b8mr180013275ab.20.1756817211839;
        Tue, 02 Sep 2025 05:46:51 -0700 (PDT)
Received: from t-chicago-u-2404 ([2001:19f0:5c00:2be4:5400:5ff:fe7e:238d])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50edbb97ee4sm2164602173.74.2025.09.02.05.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 05:46:51 -0700 (PDT)
Date: Tue, 2 Sep 2025 20:46:49 +0800
From: Ted Chen <znscnchen@gmail.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org,
	Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] KVM: Avoid debugfs warning caused by repeated vm fd
 number
Message-ID: <aLbnOUXUq7fbF6Mv@t-chicago-u-2404>
References: <20250901130336.112842-1-znscnchen@gmail.com>
 <b227a304-9b2f-4e89-9ca5-41d836ae4bae@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b227a304-9b2f-4e89-9ca5-41d836ae4bae@arm.com>

On Mon, Sep 01, 2025 at 02:39:06PM +0100, Ben Horgan wrote:
> Hi Ted,
> 
> On 9/1/25 14:03, Ted Chen wrote:
> > Avoid debugfs warning like "KVM: debugfs: duplicate directory 59904-4"
> > caused by creating VMs with the same vm fd number in a single process.
> > 
> > As shown in the below test case, two test() are executed sequentially in a
> > single process, each creating a new VM.
> > 
> > Though the 2nd test() creates a new VM after the 1st test() closes the
> > vm_fd, KVM prints warnings like "KVM: debugfs: duplicate directory 59904-4"
> > on creating the 2nd VM.
> > 
> > This is due to the dup() of the vcpu_fd in test(). So, after closing the
> > 1st vm_fd, kvm->users_count of the 1st VM is still > 0 when creating the
> > 2nd VM. So, KVM has not yet invoked kvm_destroy_vm() and
> > kvm_destroy_vm_debugfs() for the 1st VM after closing the 1st vm_fd. The
> > 2nd test() thus will be able to create a different VM with the same vm fd
> > number as the 1st VM.
> > 
> > Therefore, besides having "pid" and "fdname" in the dir_name of the
> > debugfs, add a random number to differentiate different VMs to avoid
> > printing warning, also allowing the 2nd VM to have a functional debugfs.
> > 
> > Use get_random_u32() to avoid dir_name() taking up too much memory while
> > greatly reducing the chance of printing warning.
> > 
> > void test(void)
> > {
> >         int kvm_fd, vm_fd, vcpu_fd;
> > 
> >         kvm_fd = open("/dev/kvm", O_RDWR);
> >         if (kvm_fd == -1)
> >                 return;
> > 
> >         vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
> >         if (vm_fd == -1)
> >                 return;
> >         vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> >         if (vcpu_fd == -1)
> >                 return;
> > 
> >         dup(vcpu_fd);
> >         close(vcpu_fd);
> >         close(vm_fd);
> >         close(kvm_fd);
> > }
> > 
> > int main()
> > {
> >         test();
> >         test();
> > 
> >         return 0;
> > }
> > 
> > Signed-off-by: Ted Chen <znscnchen@gmail.com>
> > ---
> >  virt/kvm/kvm_main.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 6c07dd423458..f92a60ed5de8 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1017,7 +1017,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
> >  {
> >  	static DEFINE_MUTEX(kvm_debugfs_lock);
> >  	struct dentry *dent;
> > -	char dir_name[ITOA_MAX_LEN * 2];
> > +	char dir_name[ITOA_MAX_LEN * 3];
> >  	struct kvm_stat_data *stat_data;
> >  	const struct _kvm_stats_desc *pdesc;
> >  	int i, ret = -ENOMEM;
> > @@ -1027,7 +1027,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
> >  	if (!debugfs_initialized())
> >  		return 0;
> >  
> > -	snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
> > +	snprintf(dir_name, sizeof(dir_name), "%d-%s-%u", task_pid_nr(current),
> > +		 fdname, get_random_u32());
> 
> This does make the directory names (very likely) to be unique but it's
> not helpful in distinguishing which directory maps to which vm. I wonder
> if there is some better id we could use here.
Good point. Maybe use timestamp instead?
So, we can know a bigger timestamp value corresponds to a VM created later.
Also since VMs are created in a single thread, they can't have the same
timestamp value.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..c3b0880be79a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1017,7 +1017,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 {
        static DEFINE_MUTEX(kvm_debugfs_lock);
        struct dentry *dent;
-       char dir_name[ITOA_MAX_LEN * 2];
+       char dir_name[ITOA_MAX_LEN * 4];
        struct kvm_stat_data *stat_data;
        const struct _kvm_stats_desc *pdesc;
        int i, ret = -ENOMEM;
@@ -1027,7 +1027,8 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
        if (!debugfs_initialized())
                return 0;

-       snprintf(dir_name, sizeof(dir_name), "%d-%s", task_pid_nr(current), fdname);
+       snprintf(dir_name, sizeof(dir_name), "%d-%s-%llx", task_pid_nr(current),
+                fdname, ktime_get_ns());
        mutex_lock(&kvm_debugfs_lock);
        dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
        if (dent) {


> Should the vm stats_id also be updated to be unique and use the same scheme?
I don't think so. Unlike debugfs paths that will be accessed directly by
userspace, the stats_id is used by anonymous inode files openned with unique
fd numbers in a single process. So, duplicated names should be ok.

