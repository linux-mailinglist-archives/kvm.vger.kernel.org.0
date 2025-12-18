Return-Path: <kvm+bounces-66219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 10501CCAA3C
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 08:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6E84303ADEE
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 07:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FEC2F8BC3;
	Thu, 18 Dec 2025 07:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wqh4eIuI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nXHy+XDB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225A972634
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 07:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766042673; cv=none; b=Pp1u7BnMGB2RuVixS/vCbw/cbZ5/mP9apF63ftSdCcqKRAu7sfOePvAFVCk7d8GkJJec2ltmAGj/LR1fdmSFZLuCLgn67UOqueuLLMlnlsoS/sDj7NPVdL1ayy/GaxfrioNOhyPpxvhswGo6NmtTEJ6U3NuwrsZarhPrXRi6jmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766042673; c=relaxed/simple;
	bh=EJipBEKaAn1VozskjO5QG2YhXJZWuLx6WVfDghDDChw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HT+xBNR71vlaMxCkAM7BTKm0LKIje0bvY0I8wcBZgQIxnpjmHrQOLa/abNJZXcf2j9EWGHcEpb7iKmnBdqh0WkW3/jbwkxvMmZoAbz1mSOz4Cl99a9L3yNzJek9ommgcFvNA8+0GaicLXBwGO7qipLQVBBZVpkJ8OhWEdxgvf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wqh4eIuI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nXHy+XDB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766042670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K3ZtEPXMm9tmuJEBCrK1OA4sYdQysjzwD7qLV1aPcTA=;
	b=Wqh4eIuIjm7G4zi+WoZoSc0QxiNq7m332s7/jPYXhmpIy0HjwRE283MNiRXzYobxtXywwJ
	D+578w32kZLIh7vnt3gQNhnprH73m9n1ITr3T/LH90dHz0uvucw4fo5nNnWAd5NDS5LYzH
	3hxOtGCoqHZveHVKwWsmzAG1n+618Ng=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-WPvrhEF-OP2O9gkNfSDLBg-1; Thu, 18 Dec 2025 02:24:29 -0500
X-MC-Unique: WPvrhEF-OP2O9gkNfSDLBg-1
X-Mimecast-MFC-AGG-ID: WPvrhEF-OP2O9gkNfSDLBg_1766042668
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a0e9e0fd49so16107075ad.0
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 23:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766042668; x=1766647468; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3ZtEPXMm9tmuJEBCrK1OA4sYdQysjzwD7qLV1aPcTA=;
        b=nXHy+XDBb3ncf+9m7+D3DmTVN8xzUaYQBgrYicQ6QJ8JyeEuWCssbtU5bTon76EF9a
         5x0U7itklFieKl+tFXZf2SwfTonimMU0UpDv+6T9KOaRUg9Ix/GYUTtJy2szl2RfO2+M
         JlB7JVJ8tYtH0PZ/cH4yfe3jusEP11l65gkyEmIE3mfgS4Wa5hlS3ZiGYoO07En2+15I
         oPdw2p5keZJ8PUX2oTFVQimbTOVd9Gcd/XrA879BaNnPUh2/ZjkLu+qeE6ZOc+8Ud4zA
         73fBZ5B2VZKSRgyu+Km9IcXLVgWO0AA0kweqVppiMbg+WpcD90Bm7VBxe/4FIsDv0P6d
         D5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766042668; x=1766647468;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K3ZtEPXMm9tmuJEBCrK1OA4sYdQysjzwD7qLV1aPcTA=;
        b=sP9xobvDNpr1GMCkm9lBbfdSij4AtVZwN490JGWkXWKUkARz4hG5Hl15VaxFDrTqjO
         6DKGzzi8okEWyrOTglkzmU8WL6b1Rla0GwtM+uM3/W2YaNHAPiD8AIF4jWkjhvBzjo6H
         y4Ahe0TC9ERARuCViW1slfo4leAQhNS0exdz0j2H2w74P5/ku/YxtAQo6wPiaU2apknR
         ISlCY6J6O7UT1Y+FMGSc4ZQdWfHsGEkmA7qh9vff09HamZZnWbAaCKNYtippTJpRirtc
         4cxVVmcb+6+L9rToHhayqr4xYLa6M9NNyuf2zfu0vzTHD9PtsFaLrtcXsQdfNAFytmsD
         UZaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsWvK5v3+QVQ3Mh10PSmcir4/Uwn28FxfbMWhxSr2clLN2o/MWWA2h8sXZpBr4xgwG3cc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsVUyJlg0qjkUSKTm9edOWxm1xzYloogcdl7+T97qhLe3QIGFz
	pQSa1JcPsovuR2oXvIpdomrg8wWkMmNGVCEVofnjBRIxnv7wzjrSBh/M9rDaHHMxassrvqBDSSm
	kRuSxuCN+SAg+fbNS9YEBnhv1uc542/R2iMOEbJtWKKpJ8/bkUsuBWuvLPnu2PQ==
X-Gm-Gg: AY/fxX5toYtCwOz1Dk7ZwvLaZGP7glht3IGYSZREKEPZ+y8L1aQCqPIR3UxVmrLqAgV
	Dj85H7tJmgmNFE7fCjdwUfWzd0juzwJraekQ6C9a22TI7QLAT3J2RG2lBBChYIdrBDftWvUx7EO
	ryrg8GZ18YqUKKdGe42xoTk/xf4PBqKaQDRionla7eR0w0+4g/RUdxbVwb6QFMrkC68RIUVex1F
	5IO9xn41YyKYFgg9C5yhmpY4hLxpLPU9Xo7auQy3j1rZqCaKmVevNvuxfs+UxmFT8kfkBHA51F2
	BeRc+7G6DkPwrofBpO6jNa70muHI7XrtYVQLozaSuvBdqgHTykeYu7ClkH8JJal9/ov18LRPoUa
	ZUzxgzFxmxDig4AsRcfts+JbmFox69mntKtDlkEQ4JvP68CWUtPGqow==
X-Received: by 2002:a17:902:e74c:b0:299:bda7:ae45 with SMTP id d9443c01a7336-2a2cab60b33mr20575405ad.25.1766042668188;
        Wed, 17 Dec 2025 23:24:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEI2RTezR/dqNDhaoWlutMlheYpW/nO7+H9OUpA9k3cy85NbWYu2XEhR46dmM79PrgCRvt8lQ==
X-Received: by 2002:a17:902:e74c:b0:299:bda7:ae45 with SMTP id d9443c01a7336-2a2cab60b33mr20575265ad.25.1766042667791;
        Wed, 17 Dec 2025 23:24:27 -0800 (PST)
Received: from smtpclient.apple ([27.58.53.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d1926ce0sm14633185ad.80.2025.12.17.23.24.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Dec 2025 23:24:27 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.3\))
Subject: Re: [PATCH v1 15/28] i386/sev: add migration blockers only once
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <aas37tpm2yrqueip7mhgqd7lzy5f3ckk6zrt73bzq6dawpjoox@47o27xg5acqt>
Date: Thu, 18 Dec 2025 12:54:13 +0530
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 qemu-devel <qemu-devel@nongnu.org>,
 kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6E81A25E-841B-43AE-9A85-206088A305C5@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
 <20251212150359.548787-16-anisinha@redhat.com>
 <aas37tpm2yrqueip7mhgqd7lzy5f3ckk6zrt73bzq6dawpjoox@47o27xg5acqt>
To: Gerd Hoffmann <kraxel@redhat.com>
X-Mailer: Apple Mail (2.3826.700.81.1.3)



> On 17 Dec 2025, at 5:14=E2=80=AFPM, Gerd Hoffmann <kraxel@redhat.com> =
wrote:
>=20
> On Fri, Dec 12, 2025 at 08:33:43PM +0530, Ani Sinha wrote:
>> sev_launch_finish() and sev_snp_launch_finish() could be called =
multiple times
>> if the confidential guest is capable of being reset/rebooted. The =
migration
>> blockers should not be added multiple times, once per invocation. =
This change
>> makes sure that the migration blockers are added only one time and =
not every
>> time upon invocvation of launch_finish() calls.
>=20
>> +    static bool added_migration_blocker;
>=20
>> -    error_setg(&sev_mig_blocker,
>> -               "SEV: Migration is not implemented");
>> -    migrate_add_blocker(&sev_mig_blocker, &error_fatal);
>> +    if (!added_migration_blocker) {
>> +        /* add migration blocker */
>> +        error_setg(&sev_mig_blocker,
>> +                   "SEV: Migration is not implemented");
>> +        migrate_add_blocker(&sev_mig_blocker, &error_fatal);
>> +        added_migration_blocker =3D true;
>> +    }
>=20
> Maybe move this to another place which is called only once? =20

Where do you suggest? sev_common_instance_init?

> The
> migration blocker should not be very sensitive to initialization
> ordering, so I'd expect finding another place where you don't need
> the added_migration_blocker tracker variable isn't too much of a
> problem.
>=20
> take care,
>  Gerd
>=20


