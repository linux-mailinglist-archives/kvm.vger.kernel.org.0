Return-Path: <kvm+bounces-47159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCFB2ABE0D3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 157951BA5AA5
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3198B4B1E5D;
	Tue, 20 May 2025 16:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktkRFswK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02B322D795;
	Tue, 20 May 2025 16:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747758858; cv=none; b=dTsjmPHwQYKOtQ8mz8bQm+LC3L+zU6NhiDCccCjpJR/p4cdAIa1agdyDmB1CtIpcsJ8mAqr9NlZ8csJN1XcKsSAHp9SG14V0FvFRjT+4XGBO3FAXGZ7uEjNG7qI/5Tj053aF5KaBA8Y5cUOqPEyCcmqemKrxaVdTGqNvIEAz5Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747758858; c=relaxed/simple;
	bh=VyyYOhKbGdK6Q4Vh3+ZAnFAI49OgnPA+WshnAQ64g5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jVYVCvRudql0lrnYMfKbl4oj78Y8p3q9mFMIAG1W5nXlHJdkF1HtReb1qDX1wBuuzqtxzvKN0tnJEA0F4zvFWNTDTEsKZUmfxWk5OYGF2FO/SaieSuUbR5cqk6kKqddyde4jHSIPHwd37PdEWE5WzhcohqItTEnAuitmnNgjNNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ktkRFswK; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4769f3e19a9so39497521cf.0;
        Tue, 20 May 2025 09:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747758855; x=1748363655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyyYOhKbGdK6Q4Vh3+ZAnFAI49OgnPA+WshnAQ64g5c=;
        b=ktkRFswKT/ch7S2Bayh/huowdTggpYrn+iOIYoShwoyqlTlI1or6q7bezTeWlqtE2u
         D70UcQoSJIu9xCzl6o9QT6dLJdivoiuEagy2P7YugEP8jucnYsQoOoN+qsj+Hnw7Cm/6
         jmqrbIH98vcTuFVuvi8OkmlCZX2f8QLZKdDO2WO+PWCPZlimoz4f4RqzFYEKlqiGtIyo
         zhjQ8RPcShfLUPe1yNWD4UzA1qBr1sXRRTT2opYPAzYQLlFXKXyjP/4tLiy0uv1cGvUU
         oJYIiS2DeBGqePxDOaA07lKny2rA+o4zPhuBFxw/SC3LDdj6YgFupzGTfA4e7Ult12eG
         U8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747758855; x=1748363655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VyyYOhKbGdK6Q4Vh3+ZAnFAI49OgnPA+WshnAQ64g5c=;
        b=LFxZECiFFFuj5PaBc0z9AOtUJ0u0ywnA9DA/1ltAaISdiaQPIlN1288C2IOIAvZDJ9
         dS8ut/ObS3c1qAjjg6KK7jbe4dQ6IKb2lHYHuMGTDYUVM1+idyBc7JGO2ctF7hD5N+sJ
         4NBP4OYTnLafPWSmcSspZK8LZguQMwEwhzzvIdG6/y9dfUq9090ISLCCbRTDNQOfTiSq
         3SlwYikoUE30jJ/BicT/Jp6Ta+y72Ge/9sJmFFrprJBlWikwd9IXRssMtn+AlN9YLjbH
         EigXifkrtvxPqh3lphbWBgIP7bPoaa9WizqQZZLWVlVuuYyX2Z1A43OvgBvGrgrltvvV
         rM3A==
X-Forwarded-Encrypted: i=1; AJvYcCVrdfwayBuqJ4TT4U0IKK/1CWMYAXCSPERsuqSUiqk7xt3JoMqEKcu91+z/ticQo6djJzEoxm0rOqiIqW3m@vger.kernel.org, AJvYcCW5jo8IO3qPuH651wiXxvoq2bIr+WSOu5oNd2YyV/McIyXwHAZf0aBZfEQ+XGs/0b7LPX/Z@vger.kernel.org, AJvYcCX66u0VwnPH6lz8UoU2sokGR+h/MxQtMLEXtuR8pNQNS81UGwSEqI//rG9WBDn3IE4IMJXf0A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzW0Qhl1iZQ4vLfllDsr9ojTWZ/kENj9EIXIRjjBCImtrsdahiD
	ueF+JlxuUWXlu7U9QMJA4Z5v+iuMJW/VckPUMn7muXKuOp9qdOzN1ufW
X-Gm-Gg: ASbGncscJWfFPj4qfKRtZ1AO7kdTj08/NYLjwzAisz34tnbmogvWi+lCga/sFGRZ6fD
	zxHx5mqpXcvMoVjPW3c9ZPFK4IkjV7YJLmBiDpWRsPh9Bh9CoZqtKgFdtg4DiUNEMRKuRyqVVqZ
	dsNMMx7wytvqCG4U069Xz/AaPPAPn6ORPMwjQY86FHQAvVFqhFX9gzBuHRTRn6xpXw9TKVsTmtj
	whSsJH1iLj0BpCId92GD7JhYdvfERd6uKO3+E+iLXDR69xN0NDBPL+02Y5KFiAvRheewI2B0AfW
	AbXm5oQhfhLc9Wy0KkTBpgUP6pBG5CL3dOI41ndbVrmmqAtLzClXypajT82Tmg5H4g7QMbCv4aj
	JsByM675tspMByvVoq10XCKFVNg==
X-Google-Smtp-Source: AGHT+IHF89vB9sSkJ+0Go8jzkQaq8IlhxufFTHLal/lvGAHMBlLkCEK8kQavtZYLi/oDmSbgOit/iQ==
X-Received: by 2002:a05:622a:4105:b0:494:a4c2:57fd with SMTP id d75a77b69052e-494ae34b716mr270643771cf.9.1747758855231;
        Tue, 20 May 2025 09:34:15 -0700 (PDT)
Received: from worker0.chath-257877.iommu-security-pg0.utah.cloudlab.us ([128.110.220.58])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-494ae3ccf9dsm72118821cf.12.2025.05.20.09.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 09:34:14 -0700 (PDT)
From: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
X-Google-Original-From: Chathura Rajapaksha <chath@bu.edu>
To: paul@paul-moore.com
Cc: Yunxiang.Li@amd.com,
	alex.williamson@redhat.com,
	audit@vger.kernel.org,
	avihaih@nvidia.com,
	bhelgaas@google.com,
	chath@bu.edu,
	chathura.abeyrathne.lk@gmail.com,
	eparis@redhat.com,
	kevin.tian@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	schnelle@linux.ibm.com,
	xin.zeng@intel.com,
	xwill@bu.edu,
	yahui.cao@intel.com,
	zhangdongdong@eswincomputing.com
Subject: Re: [PATCH RFC 2/2] audit accesses to unassigned PCI config regions
Date: Tue, 20 May 2025 10:33:55 -0600
Message-Id: <20250520163355.13346-1-chath@bu.edu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <669e1abd542da9fbcfb466d134f01767@paul-moore.com>
References: <669e1abd542da9fbcfb466d134f01767@paul-moore.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Bjorn and Paul,

Thank you for your comments, and sorry for the late reply.

On Mon, Apr 28, 2025 at 11:05 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> Add blank line between paragraphs.

> Use imperative mood ("Introduce" instead of "This patch introduces
> ..." and "Add ..." instead of "A new type has been introduced").

> Simplify this patch by adding "blocked" in the first patch.  Then you
> won't have to touch the permission checking that is unrelated to the
> audit logging.  Consider adding a helper to do the checking and return
> "blocked" so it doesn't clutter vfio_config_do_rw().

I will address the above comments in the next revision.

On Fri, May 16, 2025 at 4:41 PM Paul Moore <paul@paul-moore.com> wrote:
> I try to encourage people to put a sample audit record in the commit
> description as it helps others, even those not overly familiar with the
> Linux kernel, know what to expect in the audit log and provide feedback.

> > +static const char * const vfio_audit_str[VFIO_AUDIT_MAX] = {
> > +     [VFIO_AUDIT_READ]  = "READ",
> > +     [VFIO_AUDIT_WRITE] = "WRITE",
> > +};
>
> We generally don't capitalize things like this in audit, "read" and
> "write" would be preferred.

I will address the above comments in the next revision.
The following is the expected audit message when a write is performed
to an unassigned PCI config region:

  device=0000:01:00.1 access=WRITE offset=0x298 size=1 blocked=0

> In the commit description you talk about a general PCIe device issue
> in the first paragraph before going into the specifics of the VFIO
> driver.  That's all well and good, but it makes me wonder if this
> audit code above is better done as a generic PCI function that other
> PCI drivers could use if they had similar concerns?  Please correct
> me if I'm wrong, but other than symbol naming I don't see anyting
> above which is specific to VFIO.  Thoughts?

While the issue is independent of VFIO, the security and availability
concerns arise when guests are able to write to unassigned PCI config
regions on devices passed through using VFIO. That's why we thought it
would be better to audit these accesses in the VFIO driver. Given this
context, do you think it would be more appropriate to audit these
accesses through a generic PCI function instead?

> Beyond that, I might also change the "access=" field to "op=" as we
> already use the "op=" field name for similar things in audit, it would
> be good to leverage that familiarity here.  Similarly using "res=",
> specifically "res=0" for failure/blocked or "res=1" allowed, would
> better fit with audit conventions.

Thanks for the suggestions, I will address these in the next revision.

Regards,
Chathura

