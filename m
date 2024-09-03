Return-Path: <kvm+bounces-25720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38244969665
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9F6D285BE8
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE9B201276;
	Tue,  3 Sep 2024 08:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RDz1xZcD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF01200134
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 08:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725350450; cv=none; b=fKmpN3j5RE6lgY0/dDxL2uaegGLbrcz6VkctIbMUD9G/0oFEYsi6tjFxErTWFymVLa/Gpu9At7Ji12H0B+ZT4GMM98voGxrYpTRV3ILwbSgQc+niswGkaD8BU9aYBkWSnGr75WYcahUixAznvDzs3nJNKSdzxZ4hLL+Jbx4nZJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725350450; c=relaxed/simple;
	bh=cxhW2HegPndYLZPy/62xh8FEGyZhcAY0klP3M9n+2b0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=g/w9gjniuilpdfh+amqki+6Ypwuk8cZieaZE3wl9KoPc9vq3rpoU3BoF1ZvQpmhFBcXd7XVgdAEYSKcwua5DVoNMZodXYVFPj1Rq/jHRi3f6gga1JEJuUqIpytTb72DalUIkdY2dqS/ooI8lBiknv4bEMRaCmnFYTWnxm/3k8kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RDz1xZcD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725350447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQgES2SHE5kJKblMfzziYGbwwaww6AKxF4Mqvc0CMjU=;
	b=RDz1xZcDEXuXItBymzLrCGjGiQcKNqq5rr8B4zbBFu7faSSXCk7SIFfuhpAJtgKB8PF5jw
	mWsvkUdC03EgDjGJRyTN/EGl+5t7F27IoVDTNDJLhQvFlZeTYQFsxO14/2dFpXNvaF7ZQK
	eNznJfOpPUqq/aBbMFq1ZugFie+vJps=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-rdeTmMNkORu-9fU6Vny_mw-1; Tue, 03 Sep 2024 04:00:46 -0400
X-MC-Unique: rdeTmMNkORu-9fU6Vny_mw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2053f4938c7so26072585ad.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 01:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725350445; x=1725955245;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQgES2SHE5kJKblMfzziYGbwwaww6AKxF4Mqvc0CMjU=;
        b=kJLCqrAWPJYUfsjDqPLXCJ+PLRIJMamGo/rfq+gNtitxsCqw344HaGNSWIebW7EXAM
         /igrJ7ud3YPgCbTetNq/OhcCOem302oB0qy6AD2PBFdAWu3pBkLMWleaOKauLO+VWcuP
         TGFLOWfMqOUxC21t/HONF5HBsXcULMgnZ6rLwtjodXae9Mh4jmyGTzG3uyJ3/mP3quvO
         9n8RKi5zaXGJuxq2OKioOGZH4C4DCSsP2M2Drx1dGE5NuHMO5PedC+ihVImr+YT1HccV
         uMeteCSpCcXOwB3GaJ/POuDQCBl4R1tb0UHamOdiWHt6iWAGAt7/HmotUQN/yK7sfWfn
         yefQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRXhRnE6u1jr6Tt0W+GEbw+kbJPUXo4FEXmIPaVbb/3yQLGbWJ5iXzl1p+mseEDvZYg2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYNhbmD8vBy9s6df7HNe8hjeeqS6EqEbwbH1TBL/wuPnhK2hFQ
	hVkz1JRgANcHhrnmlie9UaxZ8kCD/Aynp0d99OdBn6CRIaek3Cq/mcCSPn0AMXdzLxZ4F8Jh+0d
	DFkQNGRdOcTP1GvZw9E65CL66E9K6Ah3TKHeQDeM/Ey87dab91A==
X-Received: by 2002:a17:902:f650:b0:205:5de3:b964 with SMTP id d9443c01a7336-2055de3bbe9mr48274385ad.5.1725350444986;
        Tue, 03 Sep 2024 01:00:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE45T9KeHgvKqCeFSvDtKlTMmyS8e/LokVC/OmwOZsaymL1yoXxJHhvPGWygRz6isjqiTrYRA==
X-Received: by 2002:a17:902:f650:b0:205:5de3:b964 with SMTP id d9443c01a7336-2055de3bbe9mr48274095ad.5.1725350444454;
        Tue, 03 Sep 2024 01:00:44 -0700 (PDT)
Received: from smtpclient.apple ([115.96.207.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20515537813sm76088755ad.156.2024.09.03.01.00.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2024 01:00:44 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] kvm/i386: fix a check that ensures we are running on host
 intel CPU
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <32332f54-0c20-434c-be43-e4e00bcebe29@redhat.com>
Date: Tue, 3 Sep 2024 13:30:30 +0530
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
 kvm@vger.kernel.org,
 qemu-devel <qemu-devel@nongnu.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B9CFEBF6-A926-442F-96F4-1F1345D8E921@redhat.com>
References: <20240903071942.32058-1-anisinha@redhat.com>
 <32332f54-0c20-434c-be43-e4e00bcebe29@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3776.700.51)



> On 3 Sep 2024, at 1:13=E2=80=AFPM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>=20
> On 9/3/24 09:19, Ani Sinha wrote:
>> is_host_cpu_intel() returns TRUE if the host cpu in Intel based. RAPL =
needs
>> Intel host cpus. If the host CPU is not Intel baseed, we should =
report error.
>> Fix the check accordingly.
>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>=20
> It's the function that is returning the incorrect value too; so your =
patch is breaking the feature: this line in is_host_cpu_intel()
>=20
> return strcmp(vendor, CPUID_VENDOR_INTEL);
>=20
> needs to be changed to use g_str_equal.

Ah that is why it got unnoticed as programatically it was not broken. I =
will send a v2.

>=20
> Paolo
>=20
>> ---
>>  target/i386/kvm/kvm.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 11c7619bfd..503e8d956e 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -2898,7 +2898,7 @@ static int kvm_msr_energy_thread_init(KVMState =
*s, MachineState *ms)
>>       * 1. Host cpu must be Intel cpu
>>       * 2. RAPL must be enabled on the Host
>>       */
>> -    if (is_host_cpu_intel()) {
>> +    if (!is_host_cpu_intel()) {
>>          error_report("The RAPL feature can only be enabled on hosts\
>>                        with Intel CPU models");
>>          ret =3D 1;
>=20


