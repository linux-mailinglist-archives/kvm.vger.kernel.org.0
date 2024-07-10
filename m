Return-Path: <kvm+bounces-21304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D56E92D05B
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 13:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E9B71F21B41
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 11:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0857190480;
	Wed, 10 Jul 2024 11:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="NEjGZcmL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CF518FDB7;
	Wed, 10 Jul 2024 11:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720610002; cv=fail; b=BVoqH8tjKj1KQgWHr5kEap54eytu73WjzdswmujiJd9DUL18y6N4hl3PYouvc/mEGbRwxSry16hLefEKh6hxAtujZD+rHerPqSe3bGiA+3zffQgVQws4jbmWHpUWMve5NtdEOJTAlg7gFIzscFik/ZxglwLvtXORNAkjAxFIfWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720610002; c=relaxed/simple;
	bh=th3V6jsYIuVowRspwmLV0kjWmok3MRplZnhKZhScOrE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ePuWUPYWUxckZzkb/cPaACP6UsqaxC1aa6mDRfVRm8APpZn1z7DTCwadtIlmwIEknnLm7GNCiZmFQrQbrMAeI1FvbkBQ7GOtYv7vXZOZOqWJx32NC3Oi7swhucLxO2gpQK6ZNYW4YNQOhv0xMNShaBt9rkyITVEIrY/gXSS2mrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=NEjGZcmL; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A7vmKE011217;
	Wed, 10 Jul 2024 04:13:06 -0700
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 408ntyqag3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 04:13:05 -0700 (PDT)
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46ABD53r015692;
	Wed, 10 Jul 2024 04:13:05 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 408ntyqafy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 04:13:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rk9OXoYShp5/Xtrf/TSQhiBu9SMWE1uHnFN8yIJ+5EY8VOPvzXzowfpgzYIdEVkehct/gnJdhFSFrHiiLFY9pLqtQBWIGrchqImC3zeNAXt1kTNVCbYdr184FqRaTW6qCBVRiKtZDiEd5+03gT3elDegp8nJc2wSzYm2v6gpDJX0gzPVQIghHzIOSm39evjkmOwZVT0poqwmXyi5bj8YpOBxdAFLfoIsWznMuJ22ZcowaKUitdukEvnjXkY7mTkSBXOvO0cQnx0/oMUdavXL06d96Un2rtk9gwspGZTpUvQ4J/fl3S8EqQehbOygFUqxeDp5pyt9TJN1li5dqbJxiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YfwrLM5BZ9yC+dlSPxSKpKE3Ar6bkoKgKeFLXGwyGg=;
 b=lnOkTaH2MwLuBb7MlWZ8Lv3rUNDBz3rPyeqvAOya6qshJBZNyHBXny6gqkhjedVKxY9mUmMmVPK9xfQMm+ngOCeGh5WZwgapAvLqGzn2c99FTHl7n5gluNQ2aMNjqF4lmVOn9jmTtB0qvEPuQmuuqli1m6g+/SEmPHpJ4SmyjKRIX8Caw7uv5GKWOi81sQRgeU6Yw3h8vM01BP6Tc/lQZAvrooJR86klmGanZaZq+RwkW4Z5+eyzbC+rfltXRQCz7BarC0dMIHCrfzlfs7qcjTq+9pus8FB9U+FT8TMPJjbNvhNfr41E1cFKk5y/s5EZUizYPoHr50CY7xqqfXztqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YfwrLM5BZ9yC+dlSPxSKpKE3Ar6bkoKgKeFLXGwyGg=;
 b=NEjGZcmLc9XmGtvdC4ytprfayt3Ah+BCeSxLqAvomRkpUyqcOoeuQM3kDwz9ctu17ucWIgsatSsWYNBhOFgW6jlHr074J0M6zXRKDx4ArhDi7mbX6FVPkaVlLE9gKKDREaVbZmNonwWIOC6+5AGla+HVNITN4kbCiCtQra0ixkM=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by SA1PR18MB4709.namprd18.prod.outlook.com (2603:10b6:806:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Wed, 10 Jul
 2024 11:13:00 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::b3e1:2252:a09b:a64e]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::b3e1:2252:a09b:a64e%7]) with mapi id 15.20.7762.016; Wed, 10 Jul 2024
 11:13:00 +0000
From: Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To: Yunsheng Lin <linyunsheng@huawei.com>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander
 Duyck <alexander.duyck@gmail.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Praveen Kaligineedi <pkaligineedi@google.com>,
        Shailend Chand
	<shailend@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tony Nguyen
	<anthony.l.nguyen@intel.com>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula
	<gakula@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>, Felix Fietkau
	<nbd@nbd.name>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee
	<Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias
 Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, Sagi Grimberg
	<sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Michael S. Tsirkin"
	<mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Eugenio_P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel
 Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko
	<andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Eduard
 Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
        Yonghong Song
	<yonghong.song@linux.dev>,
        KP Singh <kpsingh@kernel.org>, Stanislav Fomichev
	<sdf@fomichev.me>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Chuck
 Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, Neil Brown
	<neilb@suse.de>,
        Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
	<Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
        "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-afs@lists.infradead.org"
	<linux-afs@lists.infradead.org>,
        "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH net-next v10 04/15] mm: page_frag: add '_va'
 suffix to page_frag API
Thread-Topic: [EXTERNAL] [PATCH net-next v10 04/15] mm: page_frag: add '_va'
 suffix to page_frag API
Thread-Index: AQHa0gRJ8PcF5D5NGk6oPsj1llhdUbHvz6FA
Date: Wed, 10 Jul 2024 11:13:00 +0000
Message-ID: 
 <CO1PR18MB4666727D9631C8492F225251A1A42@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20240709132741.47751-1-linyunsheng@huawei.com>
 <20240709132741.47751-5-linyunsheng@huawei.com>
In-Reply-To: <20240709132741.47751-5-linyunsheng@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|SA1PR18MB4709:EE_
x-ms-office365-filtering-correlation-id: 4784151e-48a4-42d1-4ec5-08dca0d1425d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: 
 =?iso-8859-1?Q?S6yNmd/AVU77t6879e5rClcyR6GNegGO25DA8JaZNqpoG6PEdcorkJ6D8I?=
 =?iso-8859-1?Q?Ts4xFoHGMJFS6ZWBcjBKOG0te9rF+RWkP+HFnn6l/V/921XSzDIkgpn44H?=
 =?iso-8859-1?Q?gcfkROpeRlYTB0gxMhIOKSDpqnhnymcpBFoC68IyP3vTYBDhmoGFNDGf4B?=
 =?iso-8859-1?Q?2bp+TqeDrrHAZ00rh219tjkwE6CG0Ze37+v7TvN4OTTEiF2vrJusvWu5xC?=
 =?iso-8859-1?Q?7FzWCoo1dfSarM2Uf0wmcbm4IpuMfUqyxiJq+vF98icnxc5ngTD2lJL6gs?=
 =?iso-8859-1?Q?zGeAd/dLA1lTqi2ty1zJZCGKD1b3YFgmkSMNkKcUr4L1rMTOIcYDS7DWyb?=
 =?iso-8859-1?Q?w5BJuuynWxC2af5sVR+r1CwIkt2Dggi0VM97VOlHcUVgtyckOhepsgVHN6?=
 =?iso-8859-1?Q?0xsD0ZYe282p4i5vwMkA9BhbxWV4aGTZJ+0vllweFz1xlZxcPQ75GApquR?=
 =?iso-8859-1?Q?Cia3t5B/KCKrnbZl9pfxtfYkMdN6M1p+ijRMwxJvsoUMOEl5xxWnWOWzlg?=
 =?iso-8859-1?Q?7+YkleB72xohCAAjlkO4Hjw/QFD8NavUgVMsngvj8mgqpd3Vf95JoY8oAL?=
 =?iso-8859-1?Q?zzb4UA5wRZM6unnxLP2JU4oQy+iNkNd8LHJufHwMCF5S/Or5Q2Qioh91gm?=
 =?iso-8859-1?Q?yV7OVXQTTiS3/iPceMVpXByaK+I345O6G8fA9XULJCDNvjJaSyFUzgdyJP?=
 =?iso-8859-1?Q?90CP271QTGI3hRjIL/zZETtnN8ryXKS25w5IW4J45e4nZhP8/rLxKZ2WlA?=
 =?iso-8859-1?Q?yM1piQN11qwVpSPjdXre4X0M4xACFJ/Twv7/gEfVod0BqR4MFhfo2fkSez?=
 =?iso-8859-1?Q?RuKTXdhzubj1D+nupeIjnIwOl7EmjcE9mPaq5FWrrBXYT6BCcdUVJds44C?=
 =?iso-8859-1?Q?AUq4JD+Dj52fxkAHeCojuztqxujTPXlqyWh6NTLmnXW9rgwS71rKWc4ieT?=
 =?iso-8859-1?Q?9mNxXVLOQGG7QzVRQQtSE+h8RgykEt2n+dI09erGGSQQrVGAIhMrkE0Rc8?=
 =?iso-8859-1?Q?DaNhOeGzrHBZESuZ2peMzjLe6ML0ftoW73UtlSHgK4/G3TNTLBBM4NdXop?=
 =?iso-8859-1?Q?VooC0zUTtQVFhL/kLcGatEF3IP+sSvzls2ODcbdFKnKiL3kcFJYFe1kIvW?=
 =?iso-8859-1?Q?SJMDvZpgZlnRZHM8htI8UWvw1ty3EW2XCSsNaXltg75SHqdf1fx9KJ6xf5?=
 =?iso-8859-1?Q?rlrvIw4zgbG2reLyyCPNXv76sxWwB5aFWy0/MyzSyLNda1kDiiIILkbuGv?=
 =?iso-8859-1?Q?XtEoOIj8vFKRYjHIwvYclNh7lmfPY0fiHOyA4SHVUmpWQIdii9AeFSp6Cc?=
 =?iso-8859-1?Q?9m6FMxYksAy5Wrfp/nMC6r257H+1JAsrTU/fZwM7c0YflR19Cfvrc7waCL?=
 =?iso-8859-1?Q?0IdlXZH73YEAz7zhgcL7SHFjSoovq3Ku+ofDr3gr6E3NNgF57FwKP4ysTH?=
 =?iso-8859-1?Q?51DVjOjeUV4fsWfCFMiqGhxnv8U/7ZXubeOAIA=3D=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?hEqpyz5DuM/4tdGhDF7dWf87qV85LTKEtxMgyOi2l3SpE8zfTugfKZOlAe?=
 =?iso-8859-1?Q?dcUtKrEZrEPP5uEXVlF7avJO7qOhf1IkwU1FKivx2fpV1v/lrMfFp2JCub?=
 =?iso-8859-1?Q?5JtOczozwLRjE7Yswt9Gpw8dmaKtmfIn4Y0MHKgKm1jBKSJ63SyW4ZBBXZ?=
 =?iso-8859-1?Q?IoX39nWItVIJ6p8pcSylPWNDCj3OTfVIwLsP2kV683kp55B6YUOGfUVy23?=
 =?iso-8859-1?Q?msFRipyb9i7n8WwKUu1VRvcbtgap/1Lmz7pzx/xVC4ArrogtOdm+FRfI3g?=
 =?iso-8859-1?Q?u6qKCNSjbCeqAUhS/oU8HPRiqL1EVvIhUpHTDBZ5cYKnizmfmGMgdmxQWw?=
 =?iso-8859-1?Q?anQ2V3Fqx/0MPQKK9ZG2ciueF3BED75LjwcVUj1U6xMWWhmErC9+nNeU0a?=
 =?iso-8859-1?Q?ANSGe2tbplMW5HKNHXhCIY7Sg8C9//ITQR0U8wPy4M8mceP4NmOZw1y10s?=
 =?iso-8859-1?Q?QVBmE4YHajnzCd53DqJO4VDwWRhVgDKPSLXAsx3Tu77WRgcBwZuRCcekef?=
 =?iso-8859-1?Q?qtTr0UH5DDD/SXvX1K3/+0cWEEm5nnAPvcUon2oH5VJSGCfM8lqFtMpRZJ?=
 =?iso-8859-1?Q?XCBpdxOagF4BkyUKurc1G/kNi+V0s2WXMR5a2rxrVzMceW1FGx4pnDBbF6?=
 =?iso-8859-1?Q?MW0IZ0pw3JDEQW2v+ilScq/+tXRvjBx1bHKs3rXsI1aFJ5teypPDSe5WDP?=
 =?iso-8859-1?Q?aRPDCRX9viK/ujdL6V/hVnIKZ85IZEaoxjxVjnkl/2drJvtuwJ3D0K9g2Z?=
 =?iso-8859-1?Q?M8dqvrBUIdHAR6BTbAn6XeGpSD1VV3JIeO7V1H8RVJipNMcpSPfYYyOKi5?=
 =?iso-8859-1?Q?PCqBGt+rv5JeNm+g7QG69mbNRjGAJvTfGJdAv+aCb8EEzRtgm79eeJFHq+?=
 =?iso-8859-1?Q?ldZQ47y71vjQ9Zs1nTfvr4RrbKmdZ9MIHsi6Uuyh6hRIVyF/XZMPAWHcvR?=
 =?iso-8859-1?Q?fZhsXbCZUlZvNyQfi2kJVqe3VC8o9PVOQ/rm6R/ttWQE61UiFQ2EernprP?=
 =?iso-8859-1?Q?0AUTpjlRJNXS+Ag1GJ3Z52IkSUIAQHovyeLcOSXi0wrTjGFaIsYjaECcxV?=
 =?iso-8859-1?Q?T9LiPAEMUBKXST3tUaDD5P/1UZ7WrYhg8xEHfa1X3itB/afRia7ksQvir8?=
 =?iso-8859-1?Q?9iZ1Z9bHitaiRCvxWPntRggRJQiImVgHcHRxOSIh6UGJnNklF92T0QK9py?=
 =?iso-8859-1?Q?vF+VfiuFyrJUXzdWDQFUBoJiR745XhZq3nCMOFByhiM8PDLfsZo/X4oXTE?=
 =?iso-8859-1?Q?0taCM5VVC3/kNiER20JMWktDQiw8VdcKWTbCPFbQjMW9dx+c1ktrY5GYDT?=
 =?iso-8859-1?Q?IpBjOGAFcDa+fJtAVRLo6G83bj15UksCIs80qsdgUCe4qtHWWt6rGsKkXn?=
 =?iso-8859-1?Q?fTEdRO1pXUrqBmu/6l5/iIUop0SpPkbVxF1P4I08udJFTa8fFFGlSnhpYm?=
 =?iso-8859-1?Q?R9s6ebUgHc1FdhZGudPQRk02dohcNbNTms9BYbZHKWxYkfB/hCpT/5xDuP?=
 =?iso-8859-1?Q?lD4bfmgKNpj8Wtqn+VKzEWccECpdj1YrDTXl20SfTZyJCU/JgdeTJaFgJx?=
 =?iso-8859-1?Q?7mHqNe/a1UwpDNWKLr13mSB13eqRW3Ma2AM1ZC1GhluyYICnx41i77iI7R?=
 =?iso-8859-1?Q?QbaxN0SdQdmTY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4784151e-48a4-42d1-4ec5-08dca0d1425d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2024 11:13:00.1408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hnWk3N5YArFcDv428R7YJmqLGjhll07gyL177wWZ7DXkToZ72iT3HawSRzfUabm4haTQx235umFcH8b+/cpU5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4709
X-Proofpoint-ORIG-GUID: GpjpuZ9NOHgyGJ2tYsghIPFhRHpAbYSF
X-Proofpoint-GUID: u4G6nWw9g8SIe2ys8GGFNz-T0PV6rlfS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_06,2024-07-10_01,2024-05-17_01



From: Yunsheng Lin <linyunsheng@huawei.com>=20
Sent: Tuesday, July 9, 2024 6:57 PM
To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Yunsheng Lin <lin=
yunsheng@huawei.com>; Alexander Duyck <alexander.duyck@gmail.com>; Jeroen d=
e Borst <jeroendb@google.com>; Praveen Kaligineedi <pkaligineedi@google.com=
>; Shailend Chand <shailend@google.com>; Eric Dumazet <edumazet@google.com>=
; Tony Nguyen <anthony.l.nguyen@intel.com>; Przemek Kitszel <przemyslaw.kit=
szel@intel.com>; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Geethasowjan=
ya Akula <gakula@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.co=
m>; Hariprasad Kelam <hkelam@marvell.com>; Felix Fietkau <nbd@nbd.name>; Se=
an Wang <sean.wang@mediatek.com>; Mark Lee <Mark-MC.Lee@mediatek.com>; Lore=
nzo Bianconi <lorenzo@kernel.org>; Matthias Brugger <matthias.bgg@gmail.com=
>; AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>; Ke=
ith Busch <kbusch@kernel.org>; Jens Axboe <axboe@kernel.dk>; Christoph Hell=
wig <hch@lst.de>; Sagi Grimberg <sagi@grimberg.me>; Chaitanya Kulkarni <kch=
@nvidia.com>; Michael S. Tsirkin <mst@redhat.com>; Jason Wang <jasowang@red=
hat.com>; Eugenio P=E9rez <eperezma@redhat.com>; Andrew Morton <akpm@linux-=
foundation.org>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann <dani=
el@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend=
 <john.fastabend@gmail.com>; Andrii Nakryiko <andrii@kernel.org>; Martin Ka=
Fai Lau <martin.lau@linux.dev>; Eduard Zingerman <eddyz87@gmail.com>; Song =
Liu <song@kernel.org>; Yonghong Song <yonghong.song@linux.dev>; KP Singh <k=
psingh@kernel.org>; Stanislav Fomichev <sdf@fomichev.me>; Hao Luo <haoluo@g=
oogle.com>; Jiri Olsa <jolsa@kernel.org>; David Howells <dhowells@redhat.co=
m>; Marc Dionne <marc.dionne@auristor.com>; Trond Myklebust <trondmy@kernel=
.org>; Anna Schumaker <anna@kernel.org>; Chuck Lever <chuck.lever@oracle.co=
m>; Jeff Layton <jlayton@kernel.org>; Neil Brown <neilb@suse.de>; Olga Korn=
ievskaia <kolga@netapp.com>; Dai Ngo <Dai.Ngo@oracle.com>; Tom Talpey <tom@=
talpey.com>; intel-wired-lan@lists.osuosl.org; linux-arm-kernel@lists.infra=
dead.org; linux-mediatek@lists.infradead.org; linux-nvme@lists.infradead.or=
g; kvm@vger.kernel.org; virtualization@lists.linux.dev; linux-mm@kvack.org;=
 bpf@vger.kernel.org; linux-afs@lists.infradead.org; linux-nfs@vger.kernel.=
org
Subject: [PATCH net-next v10 04/15] mm: page_frag: add '_va' suffix to page=
_frag API

Currently the page_frag API is returning 'virtual address'
or 'va' when allocing and expecting 'virtual address' or
'va' as input when freeing.

As we are about to support new use cases that the caller
need to deal with 'struct page' or need to deal with both
'va' and 'struct page'. In order to differentiate the API
handling between 'va' and 'struct page', add '_va' suffix
to the corresponding API mirroring the page_pool_alloc_va()
API of the page_pool. So that callers expecting to deal with
va, page or both va and page may call page_frag_alloc_va*,
page_frag_alloc_pg*, or page_frag_alloc* API accordingly.

CC: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Looks good.

Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c      |  4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 ++--
 .../marvell/octeontx2/nic/otx2_common.c       |  2 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c    |  4 ++--
 drivers/nvme/host/tcp.c                       |  8 +++----
 drivers/nvme/target/tcp.c                     | 22 +++++++++----------
 drivers/vhost/net.c                           |  6 ++---
 include/linux/page_frag_cache.h               | 21 +++++++++---------
 include/linux/skbuff.h                        |  2 +-
 kernel/bpf/cpumap.c                           |  2 +-
 mm/page_frag_cache.c                          | 12 +++++-----
 mm/page_frag_test.c                           | 13 ++++++-----
 net/core/skbuff.c                             | 14 ++++++------
 net/core/xdp.c                                |  2 +-
 net/rxrpc/txbuf.c                             | 15 +++++++------
 net/sunrpc/svcsock.c                          |  6 ++---
 19 files changed, 74 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/etherne=
t/google/gve/gve_rx.c
index acb73d4d0de6..b6c10100e462 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -729,7 +729,7 @@ static int gve_xdp_redirect(struct net_device *dev, str=
uct gve_rx_ring *rx,
=20
 	total_len =3D headroom + SKB_DATA_ALIGN(len) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	frame =3D page_frag_alloc(&rx->page_cache, total_len, GFP_ATOMIC);
+	frame =3D page_frag_alloc_va(&rx->page_cache, total_len, GFP_ATOMIC);
 	if (!frame) {
 		u64_stats_update_begin(&rx->statss);
 		rx->xdp_alloc_fails++;
@@ -742,7 +742,7 @@ static int gve_xdp_redirect(struct net_device *dev, str=
uct gve_rx_ring *rx,
=20
 	err =3D xdp_do_redirect(dev, &new, xdp_prog);
 	if (err)
-		page_frag_free(frame);
+		page_frag_free_va(frame);
=20
 	return err;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethern=
et/intel/ice/ice_txrx.c
index 8bb743f78fcb..399b317c509d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -126,7 +126,7 @@ ice_unmap_and_free_tx_buf(struct ice_tx_ring *ring, str=
uct ice_tx_buf *tx_buf)
 		dev_kfree_skb_any(tx_buf->skb);
 		break;
 	case ICE_TX_BUF_XDP_TX:
-		page_frag_free(tx_buf->raw_buf);
+		page_frag_free_va(tx_buf->raw_buf);
 		break;
 	case ICE_TX_BUF_XDP_XMIT:
 		xdp_return_frame(tx_buf->xdpf);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethern=
et/intel/ice/ice_txrx.h
index feba314a3fe4..6379f57d8228 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -148,7 +148,7 @@ static inline int ice_skb_pad(void)
  * @ICE_TX_BUF_DUMMY: dummy Flow Director packet, unmap and kfree()
  * @ICE_TX_BUF_FRAG: mapped skb OR &xdp_buff frag, only unmap DMA
  * @ICE_TX_BUF_SKB: &sk_buff, unmap and consume_skb(), update stats
- * @ICE_TX_BUF_XDP_TX: &xdp_buff, unmap and page_frag_free(), stats
+ * @ICE_TX_BUF_XDP_TX: &xdp_buff, unmap and page_frag_free_va(), stats
  * @ICE_TX_BUF_XDP_XMIT: &xdp_frame, unmap and xdp_return_frame(), stats
  * @ICE_TX_BUF_XSK_TX: &xdp_buff on XSk queue, xsk_buff_free(), stats
  */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/et=
hernet/intel/ice/ice_txrx_lib.c
index 2719f0e20933..a1a41a14df0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -250,7 +250,7 @@ ice_clean_xdp_tx_buf(struct device *dev, struct ice_tx_=
buf *tx_buf,
=20
 	switch (tx_buf->type) {
 	case ICE_TX_BUF_XDP_TX:
-		page_frag_free(tx_buf->raw_buf);
+		page_frag_free_va(tx_buf->raw_buf);
 		break;
 	case ICE_TX_BUF_XDP_XMIT:
 		xdp_return_frame_bulk(tx_buf->xdpf, bq);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/ne=
t/ethernet/intel/ixgbevf/ixgbevf_main.c
index b938dc06045d..fcd1b149a45d 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -303,7 +303,7 @@ static bool ixgbevf_clean_tx_irq(struct ixgbevf_q_vecto=
r *q_vector,
=20
 		/* free the skb */
 		if (ring_is_xdp(tx_ring))
-			page_frag_free(tx_buffer->data);
+			page_frag_free_va(tx_buffer->data);
 		else
 			napi_consume_skb(tx_buffer->skb, napi_budget);
=20
@@ -2413,7 +2413,7 @@ static void ixgbevf_clean_tx_ring(struct ixgbevf_ring=
 *tx_ring)
=20
 		/* Free all the Tx ring sk_buffs */
 		if (ring_is_xdp(tx_ring))
-			page_frag_free(tx_buffer->data);
+			page_frag_free_va(tx_buffer->data);
 		else
 			dev_kfree_skb_any(tx_buffer->skb);
=20
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 87d5776e3b88..a485e988fa1d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -553,7 +553,7 @@ static int __otx2_alloc_rbuf(struct otx2_nic *pfvf, str=
uct otx2_pool *pool,
 	*dma =3D dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
 				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(pfvf->dev, *dma))) {
-		page_frag_free(buf);
+		page_frag_free_va(buf);
 		return -ENOMEM;
 	}
=20
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ether=
net/mediatek/mtk_wed_wo.c
index 7063c78bd35f..c4228719f8a4 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -142,8 +142,8 @@ mtk_wed_wo_queue_refill(struct mtk_wed_wo *wo, struct m=
tk_wed_wo_queue *q,
 		dma_addr_t addr;
 		void *buf;
=20
-		buf =3D page_frag_alloc(&q->cache, q->buf_size,
-				      GFP_ATOMIC | GFP_DMA32);
+		buf =3D page_frag_alloc_va(&q->cache, q->buf_size,
+					 GFP_ATOMIC | GFP_DMA32);
 		if (!buf)
 			break;
=20
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8b5e4327fe83..4b7a897897fc 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -506,7 +506,7 @@ static void nvme_tcp_exit_request(struct blk_mq_tag_set=
 *set,
 {
 	struct nvme_tcp_request *req =3D blk_mq_rq_to_pdu(rq);
=20
-	page_frag_free(req->pdu);
+	page_frag_free_va(req->pdu);
 }
=20
 static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
@@ -520,7 +520,7 @@ static int nvme_tcp_init_request(struct blk_mq_tag_set =
*set,
 	struct nvme_tcp_queue *queue =3D &ctrl->queues[queue_idx];
 	u8 hdgst =3D nvme_tcp_hdgst_len(queue);
=20
-	req->pdu =3D page_frag_alloc(&queue->pf_cache,
+	req->pdu =3D page_frag_alloc_va(&queue->pf_cache,
 		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
 		GFP_KERNEL | __GFP_ZERO);
 	if (!req->pdu)
@@ -1337,7 +1337,7 @@ static void nvme_tcp_free_async_req(struct nvme_tcp_c=
trl *ctrl)
 {
 	struct nvme_tcp_request *async =3D &ctrl->async_req;
=20
-	page_frag_free(async->pdu);
+	page_frag_free_va(async->pdu);
 }
=20
 static int nvme_tcp_alloc_async_req(struct nvme_tcp_ctrl *ctrl)
@@ -1346,7 +1346,7 @@ static int nvme_tcp_alloc_async_req(struct nvme_tcp_c=
trl *ctrl)
 	struct nvme_tcp_request *async =3D &ctrl->async_req;
 	u8 hdgst =3D nvme_tcp_hdgst_len(queue);
=20
-	async->pdu =3D page_frag_alloc(&queue->pf_cache,
+	async->pdu =3D page_frag_alloc_va(&queue->pf_cache,
 		sizeof(struct nvme_tcp_cmd_pdu) + hdgst,
 		GFP_KERNEL | __GFP_ZERO);
 	if (!async->pdu)
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 380f22ee3ebb..bea3aa79ef43 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1463,24 +1463,24 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_que=
ue *queue,
 	c->queue =3D queue;
 	c->req.port =3D queue->port->nport;
=20
-	c->cmd_pdu =3D page_frag_alloc(&queue->pf_cache,
+	c->cmd_pdu =3D page_frag_alloc_va(&queue->pf_cache,
 			sizeof(*c->cmd_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
 	if (!c->cmd_pdu)
 		return -ENOMEM;
 	c->req.cmd =3D &c->cmd_pdu->cmd;
=20
-	c->rsp_pdu =3D page_frag_alloc(&queue->pf_cache,
+	c->rsp_pdu =3D page_frag_alloc_va(&queue->pf_cache,
 			sizeof(*c->rsp_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
 	if (!c->rsp_pdu)
 		goto out_free_cmd;
 	c->req.cqe =3D &c->rsp_pdu->cqe;
=20
-	c->data_pdu =3D page_frag_alloc(&queue->pf_cache,
+	c->data_pdu =3D page_frag_alloc_va(&queue->pf_cache,
 			sizeof(*c->data_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
 	if (!c->data_pdu)
 		goto out_free_rsp;
=20
-	c->r2t_pdu =3D page_frag_alloc(&queue->pf_cache,
+	c->r2t_pdu =3D page_frag_alloc_va(&queue->pf_cache,
 			sizeof(*c->r2t_pdu) + hdgst, GFP_KERNEL | __GFP_ZERO);
 	if (!c->r2t_pdu)
 		goto out_free_data;
@@ -1495,20 +1495,20 @@ static int nvmet_tcp_alloc_cmd(struct nvmet_tcp_que=
ue *queue,
=20
 	return 0;
 out_free_data:
-	page_frag_free(c->data_pdu);
+	page_frag_free_va(c->data_pdu);
 out_free_rsp:
-	page_frag_free(c->rsp_pdu);
+	page_frag_free_va(c->rsp_pdu);
 out_free_cmd:
-	page_frag_free(c->cmd_pdu);
+	page_frag_free_va(c->cmd_pdu);
 	return -ENOMEM;
 }
=20
 static void nvmet_tcp_free_cmd(struct nvmet_tcp_cmd *c)
 {
-	page_frag_free(c->r2t_pdu);
-	page_frag_free(c->data_pdu);
-	page_frag_free(c->rsp_pdu);
-	page_frag_free(c->cmd_pdu);
+	page_frag_free_va(c->r2t_pdu);
+	page_frag_free_va(c->data_pdu);
+	page_frag_free_va(c->rsp_pdu);
+	page_frag_free_va(c->cmd_pdu);
 }
=20
 static int nvmet_tcp_alloc_cmds(struct nvmet_tcp_queue *queue)
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f16279351db5..6691fac01e0d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -686,8 +686,8 @@ static int vhost_net_build_xdp(struct vhost_net_virtque=
ue *nvq,
 		return -ENOSPC;
=20
 	buflen +=3D SKB_DATA_ALIGN(len + pad);
-	buf =3D page_frag_alloc_align(&net->pf_cache, buflen, GFP_KERNEL,
-				    SMP_CACHE_BYTES);
+	buf =3D page_frag_alloc_va_align(&net->pf_cache, buflen, GFP_KERNEL,
+				       SMP_CACHE_BYTES);
 	if (unlikely(!buf))
 		return -ENOMEM;
=20
@@ -734,7 +734,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtque=
ue *nvq,
 	return 0;
=20
 err:
-	page_frag_free(buf);
+	page_frag_free_va(buf);
 	return ret;
 }
=20
diff --git a/include/linux/page_frag_cache.h b/include/linux/page_frag_cach=
e.h
index ed8bacbb877b..185d875e3e6b 100644
--- a/include/linux/page_frag_cache.h
+++ b/include/linux/page_frag_cache.h
@@ -28,23 +28,24 @@ struct page_frag_cache {
=20
 void page_frag_cache_drain(struct page_frag_cache *nc);
 void __page_frag_cache_drain(struct page *page, unsigned int count);
-void *__page_frag_alloc_align(struct page_frag_cache *nc, unsigned int fra=
gsz,
-			      gfp_t gfp_mask, unsigned int align_mask);
+void *__page_frag_alloc_va_align(struct page_frag_cache *nc,
+				 unsigned int fragsz, gfp_t gfp_mask,
+				 unsigned int align_mask);
=20
-static inline void *page_frag_alloc_align(struct page_frag_cache *nc,
-					  unsigned int fragsz, gfp_t gfp_mask,
-					  unsigned int align)
+static inline void *page_frag_alloc_va_align(struct page_frag_cache *nc,
+					     unsigned int fragsz,
+					     gfp_t gfp_mask, unsigned int align)
 {
 	WARN_ON_ONCE(!is_power_of_2(align));
-	return __page_frag_alloc_align(nc, fragsz, gfp_mask, -align);
+	return __page_frag_alloc_va_align(nc, fragsz, gfp_mask, -align);
 }
=20
-static inline void *page_frag_alloc(struct page_frag_cache *nc,
-				    unsigned int fragsz, gfp_t gfp_mask)
+static inline void *page_frag_alloc_va(struct page_frag_cache *nc,
+				       unsigned int fragsz, gfp_t gfp_mask)
 {
-	return __page_frag_alloc_align(nc, fragsz, gfp_mask, ~0u);
+	return __page_frag_alloc_va_align(nc, fragsz, gfp_mask, ~0u);
 }
=20
-void page_frag_free(void *addr);
+void page_frag_free_va(void *addr);
=20
 #endif
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e0e2be5194fb..fb74725d1af8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3381,7 +3381,7 @@ static inline struct sk_buff *netdev_alloc_skb_ip_ali=
gn(struct net_device *dev,
=20
 static inline void skb_free_frag(void *addr)
 {
-	page_frag_free(addr);
+	page_frag_free_va(addr);
 }
=20
 void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask=
);
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index fbdf5a1aabfe..3b70b6b071b9 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -323,7 +323,7 @@ static int cpu_map_kthread_run(void *data)
=20
 			/* Bring struct page memory area to curr CPU. Read by
 			 * build_skb_around via page_is_pfmemalloc(), and when
-			 * freed written by page_frag_free call.
+			 * freed written by page_frag_free_va call.
 			 */
 			prefetchw(page);
 		}
diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index ef0a02f12acc..373f3bc29fcb 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -69,9 +69,9 @@ void __page_frag_cache_drain(struct page *page, unsigned =
int count)
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
=20
-void *__page_frag_alloc_align(struct page_frag_cache *nc,
-			      unsigned int fragsz, gfp_t gfp_mask,
-			      unsigned int align_mask)
+void *__page_frag_alloc_va_align(struct page_frag_cache *nc,
+				 unsigned int fragsz, gfp_t gfp_mask,
+				 unsigned int align_mask)
 {
 	int aligned_remaining, remaining;
 	unsigned int size =3D PAGE_SIZE;
@@ -144,16 +144,16 @@ void *__page_frag_alloc_align(struct page_frag_cache =
*nc,
=20
 	return nc->va + (size - aligned_remaining);
 }
-EXPORT_SYMBOL(__page_frag_alloc_align);
+EXPORT_SYMBOL(__page_frag_alloc_va_align);
=20
 /*
  * Frees a page fragment allocated out of either a compound or order 0 pag=
e.
  */
-void page_frag_free(void *addr)
+void page_frag_free_va(void *addr)
 {
 	struct page *page =3D virt_to_head_page(addr);
=20
 	if (unlikely(put_page_testzero(page)))
 		free_unref_page(page, compound_order(page));
 }
-EXPORT_SYMBOL(page_frag_free);
+EXPORT_SYMBOL(page_frag_free_va);
diff --git a/mm/page_frag_test.c b/mm/page_frag_test.c
index 755d66af9fd4..50166a059c7d 100644
--- a/mm/page_frag_test.c
+++ b/mm/page_frag_test.c
@@ -276,7 +276,7 @@ static int page_frag_pop_thread(void *arg)
=20
 		if (obj) {
 			nr--;
-			page_frag_free(obj);
+			page_frag_free_va(obj);
 		} else {
 			cond_resched();
 		}
@@ -304,17 +304,20 @@ static int page_frag_push_thread(void *arg)
 		int ret;
=20
 		if (test_align)
-			va =3D page_frag_alloc_align(&test_frag, test_alloc_len,
-						   GFP_KERNEL, SMP_CACHE_BYTES);
+			va =3D page_frag_alloc_va_align(&test_frag,
+						      test_alloc_len,
+						      GFP_KERNEL,
+						      SMP_CACHE_BYTES);
 		else
-			va =3D page_frag_alloc(&test_frag, test_alloc_len, GFP_KERNEL);
+			va =3D page_frag_alloc_va(&test_frag, test_alloc_len,
+						GFP_KERNEL);
=20
 		if (!va)
 			continue;
=20
 		ret =3D objpool_push(va, pool);
 		if (ret) {
-			page_frag_free(va);
+			page_frag_free_va(va);
 			cond_resched();
 		} else {
 			nr--;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 83f8cd8aa2d1..4b8acd967793 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -314,8 +314,8 @@ void *__napi_alloc_frag_align(unsigned int fragsz, unsi=
gned int align_mask)
 	fragsz =3D SKB_DATA_ALIGN(fragsz);
=20
 	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
-	data =3D __page_frag_alloc_align(&nc->page, fragsz, GFP_ATOMIC,
-				       align_mask);
+	data =3D __page_frag_alloc_va_align(&nc->page, fragsz, GFP_ATOMIC,
+					  align_mask);
 	local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
 	return data;
=20
@@ -330,8 +330,8 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, un=
signed int align_mask)
 		struct page_frag_cache *nc =3D this_cpu_ptr(&netdev_alloc_cache);
=20
 		fragsz =3D SKB_DATA_ALIGN(fragsz);
-		data =3D __page_frag_alloc_align(nc, fragsz, GFP_ATOMIC,
-					       align_mask);
+		data =3D __page_frag_alloc_va_align(nc, fragsz, GFP_ATOMIC,
+						  align_mask);
 	} else {
 		local_bh_disable();
 		data =3D __napi_alloc_frag_align(fragsz, align_mask);
@@ -748,14 +748,14 @@ struct sk_buff *__netdev_alloc_skb(struct net_device =
*dev, unsigned int len,
=20
 	if (in_hardirq() || irqs_disabled()) {
 		nc =3D this_cpu_ptr(&netdev_alloc_cache);
-		data =3D page_frag_alloc(nc, len, gfp_mask);
+		data =3D page_frag_alloc_va(nc, len, gfp_mask);
 		pfmemalloc =3D nc->pfmemalloc;
 	} else {
 		local_bh_disable();
 		local_lock_nested_bh(&napi_alloc_cache.bh_lock);
=20
 		nc =3D this_cpu_ptr(&napi_alloc_cache.page);
-		data =3D page_frag_alloc(nc, len, gfp_mask);
+		data =3D page_frag_alloc_va(nc, len, gfp_mask);
 		pfmemalloc =3D nc->pfmemalloc;
=20
 		local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
@@ -845,7 +845,7 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi=
, unsigned int len)
 	} else {
 		len =3D SKB_HEAD_ALIGN(len);
=20
-		data =3D page_frag_alloc(&nc->page, len, gfp_mask);
+		data =3D page_frag_alloc_va(&nc->page, len, gfp_mask);
 		pfmemalloc =3D nc->page.pfmemalloc;
 	}
 	local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 022c12059cf2..23b318459a01 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -389,7 +389,7 @@ void __xdp_return(void *data, struct xdp_mem_info *mem,=
 bool napi_direct,
 		page_pool_put_full_page(page->pp, page, napi_direct);
 		break;
 	case MEM_TYPE_PAGE_SHARED:
-		page_frag_free(data);
+		page_frag_free_va(data);
 		break;
 	case MEM_TYPE_PAGE_ORDER0:
 		page =3D virt_to_page(data); /* Assumes order0 page*/
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index c3913d8a50d3..dccb0353ee84 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -33,8 +33,8 @@ struct rxrpc_txbuf *rxrpc_alloc_data_txbuf(struct rxrpc_c=
all *call, size_t data_
=20
 	data_align =3D umax(data_align, L1_CACHE_BYTES);
 	mutex_lock(&call->conn->tx_data_alloc_lock);
-	buf =3D page_frag_alloc_align(&call->conn->tx_data_alloc, total, gfp,
-				    data_align);
+	buf =3D page_frag_alloc_va_align(&call->conn->tx_data_alloc, total, gfp,
+				       data_align);
 	mutex_unlock(&call->conn->tx_data_alloc_lock);
 	if (!buf) {
 		kfree(txb);
@@ -96,17 +96,18 @@ struct rxrpc_txbuf *rxrpc_alloc_ack_txbuf(struct rxrpc_=
call *call, size_t sack_s
 	if (!txb)
 		return NULL;
=20
-	buf =3D page_frag_alloc(&call->local->tx_alloc,
-			      sizeof(*whdr) + sizeof(*ack) + 1 + 3 + sizeof(*trailer), gfp);
+	buf =3D page_frag_alloc_va(&call->local->tx_alloc,
+				 sizeof(*whdr) + sizeof(*ack) + 1 + 3 + sizeof(*trailer), gfp);
 	if (!buf) {
 		kfree(txb);
 		return NULL;
 	}
=20
 	if (sack_size) {
-		buf2 =3D page_frag_alloc(&call->local->tx_alloc, sack_size, gfp);
+		buf2 =3D page_frag_alloc_va(&call->local->tx_alloc, sack_size,
+					  gfp);
 		if (!buf2) {
-			page_frag_free(buf);
+			page_frag_free_va(buf);
 			kfree(txb);
 			return NULL;
 		}
@@ -180,7 +181,7 @@ static void rxrpc_free_txbuf(struct rxrpc_txbuf *txb)
 			  rxrpc_txbuf_free);
 	for (i =3D 0; i < txb->nr_kvec; i++)
 		if (txb->kvec[i].iov_base)
-			page_frag_free(txb->kvec[i].iov_base);
+			page_frag_free_va(txb->kvec[i].iov_base);
 	kfree(txb);
 	atomic_dec(&rxrpc_nr_txbuf);
 }
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 6b3f01beb294..42d20412c1c3 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1222,8 +1222,8 @@ static int svc_tcp_sendmsg(struct svc_sock *svsk, str=
uct svc_rqst *rqstp,
 	/* The stream record marker is copied into a temporary page
 	 * fragment buffer so that it can be included in rq_bvec.
 	 */
-	buf =3D page_frag_alloc(&svsk->sk_frag_cache, sizeof(marker),
-			      GFP_KERNEL);
+	buf =3D page_frag_alloc_va(&svsk->sk_frag_cache, sizeof(marker),
+				 GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	memcpy(buf, &marker, sizeof(marker));
@@ -1235,7 +1235,7 @@ static int svc_tcp_sendmsg(struct svc_sock *svsk, str=
uct svc_rqst *rqstp,
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
 		      1 + count, sizeof(marker) + rqstp->rq_res.len);
 	ret =3D sock_sendmsg(svsk->sk_sock, &msg);
-	page_frag_free(buf);
+	page_frag_free_va(buf);
 	if (ret < 0)
 		return ret;
 	*sentp +=3D ret;
--=20
2.33.0


