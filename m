Return-Path: <kvm+bounces-19087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6F2900BD3
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 20:18:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5E0AFB21845
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 18:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B18B13D29E;
	Fri,  7 Jun 2024 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K8wwPA6p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B01C4D9F6;
	Fri,  7 Jun 2024 18:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717784300; cv=none; b=LfWdHVYA4OlZfjgofZMSXDbh+fETCsos4dCPhokw1HnxvWeh+6BgxHPb4kAS8qRVRmH2qzNsPqvEjsAptZ3SQA8FY186RaVMBTG/WljLieo420p3SpUiLrTe7UtDRMgU7KSzHh+aNdkJuiW1cWW3VDFuhY788ZRArynry2Q8vfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717784300; c=relaxed/simple;
	bh=5JpkYyQUWLN+xyr/JvA/2oGR+WmnEnSD2h3usXzErDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mEPSdWmOMCzw7qxp3j4tVpj6lGNX7kCC1ksvUE7dvNN415v9z+/zsDrbrBMN7JIiwXSu6OrLPPNM31o0nrHacL3kVEwU8Z+Q5QE3rXyksAFIXZWCiLpGcbZgGtN1lCEFECWk+xA5HvXlXc5wqc4lCYGMT0K+QdRy8MYPU20qAgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K8wwPA6p; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-57c681dd692so324017a12.3;
        Fri, 07 Jun 2024 11:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717784297; x=1718389097; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ki62ROu4ZJlTvDhZ3YNoMM9LkVRCxfxHNw+RD9Gzvkc=;
        b=K8wwPA6pi4ptuseodtUPvRNoKImjfwgk91AmVCZo1+ftC71ZSIB7iYggg/iaIotuTs
         uLvQ1qRizCtRC0ZVWQoZDeV6u9XKdVECiQHxNMIQOTwMMyUVzqLSpXHM8aeYRps9ariW
         ua0k6YJTvIKqhZte/X/a9Vp4wE8rwbRCY1pddy5jl8rMtgkqhbuvePiWJ1Qd43aA7QpY
         g4G6V8vwUUZAXMrroIxLxvIv1SSNDaShorcP5xlMA8ZJiBdF3tYR0BUaklTDduEMuece
         +tdv7dEnQwHOxfXT7d/E3uR5tbPiLMfBwmZ4sgAbkXsLxtGLZhivd3GpcQCt1LHEVbs9
         ZstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717784297; x=1718389097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ki62ROu4ZJlTvDhZ3YNoMM9LkVRCxfxHNw+RD9Gzvkc=;
        b=WcW8Tc1kV7h35SZAA1vQFnyvb/nPe/kzVerQxlOmQ5VluJqiIfxupbAAOjYA5J3awv
         DHm7t8s/lY/OBTwV4O9f23JIRg591qS89I+z3rqtG83y5i2nMS5uYp67Mh16aHXp5T/G
         Igd4uWUnDEUJERd3pOyNu6lKFUIZMaZieW26TW6nbX9CLB4eiEisKFRjZCqnlM/lQfMv
         wS3S/sqgJKBBq/KNQ6a+jft0cJLSb7HhgMi6VHWhCYB9yO+J/W0ERC4hbetEGeZW49CC
         YolzhE5IbvipICwedyX40hRlDjdeqPhmq5Kja9Kr8k2vd6sWvcP+wSRSLhcqbIIFc8gP
         K5Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWZcLV2zeBNEp2OadZfeQL30nASjCDeulyPUgGRxfH5qI53nG8EnisO0cInpivc+dDUB6XLav2m89TI6X8K6KLW4p24JsgbGGb0fJ1JALhSYm63HMXKKtB8yNbT3OoYQc0Cv/qBdAx+pgETw5iZEmpztQnpnRe3rRlBZw==
X-Gm-Message-State: AOJu0Yyu+mbkv9YaFDOYx5XNNQRV+2LQWpXqVjk5pMA1jyvLktgo9oWg
	HIg8Q4IkmssOwIIvWv0Tn5P3oGaoeNuBYlm7DltJbBWaIc29QHCOmFLwOAnkNFU8Nw0Qy5xnhEv
	RNy7/OAo+6gXEPGKoliLDf0KeuQY=
X-Google-Smtp-Source: AGHT+IHcXlBwnhFwbEMEOX/J/9t8DvROoCeBcg6wmiALfaEKm0vAs3KYLT4IFQiQWjrWCFR2K6s+GJnw6asT7x02bYQ=
X-Received: by 2002:a50:8e49:0:b0:57c:4875:10a9 with SMTP id
 4fb4d7f45d1cf-57c50935134mr1982735a12.24.1717784297289; Fri, 07 Jun 2024
 11:18:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240606151017.41623-1-fgriffo@amazon.co.uk> <20240606151017.41623-2-fgriffo@amazon.co.uk>
 <8936c102-725d-4496-b014-cc3edfccf4dd@redhat.com> <ZmM1SWBf5rb7P2je@slm.duckdns.org>
In-Reply-To: <ZmM1SWBf5rb7P2je@slm.duckdns.org>
From: Frederic Griffoul <griffoul@gmail.com>
Date: Fri, 7 Jun 2024 19:18:06 +0100
Message-ID: <CAF2vKzOr6_c9TJ7eWH4B_q7CuB=549MpW=48NQw3mpT+gu23Lg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cgroup/cpuset: export cpuset_cpus_allowed()
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Fred Griffoul <fgriffo@amazon.co.uk>, 
	kernel test robot <lkp@intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
	Eric Auger <eric.auger@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Ye Bin <yebin10@huawei.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks. Unfortunately exporting cpuset_cpus_allowed() is not enough.
When CONFIG_CPUSETS is _not_ defined, the function is inline to return
task_cpu_possible_mask(). On arm64 the latter checks the static key
arm64_mismatched_32bit_el0, and thus this symbol must be exported too.

I wonder whether it would be better to avoid inlining cpuset_cpus_allowed()
in this case.

Br,

Fred

On Fri, Jun 7, 2024 at 5:29=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> On Thu, Jun 06, 2024 at 11:45:37AM -0400, Waiman Long wrote:
> >
> > On 6/6/24 11:10, Fred Griffoul wrote:
> > > A subsequent patch calls cpuset_cpus_allowed() in the vfio driver pci
> > > code. Export the symbol to be able to build the vfio driver as a kern=
el
> > > module.
> > >
> > > Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202406060731.L3NSR1Hy-l=
kp@intel.com/
> > > ---
> > >   kernel/cgroup/cpuset.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > >
> > > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > > index 4237c8748715..9fd56222aa4b 100644
> > > --- a/kernel/cgroup/cpuset.c
> > > +++ b/kernel/cgroup/cpuset.c
> > > @@ -4764,6 +4764,7 @@ void cpuset_cpus_allowed(struct task_struct *ts=
k, struct cpumask *pmask)
> > >     rcu_read_unlock();
> > >     spin_unlock_irqrestore(&callback_lock, flags);
> > >   }
> > > +EXPORT_SYMBOL_GPL(cpuset_cpus_allowed);
> > >   /**
> > >    * cpuset_cpus_allowed_fallback - final fallback before complete ca=
tastrophe.
> >
> > LGTM
> >
> > Acked-by: Waiman Long <longman@redhat.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> If more convenient, please feel free to route the patch with the rest of =
the
> series. If you want it applied to the cgroup tree, please let me know.
>
> Thanks.
>
> --
> tejun

