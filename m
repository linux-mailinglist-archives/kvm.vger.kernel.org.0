Return-Path: <kvm+bounces-67975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F36A8D1B169
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 20:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A3643033BAD
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 19:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E3336C5A7;
	Tue, 13 Jan 2026 19:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="b2sV9fHY";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mEa4ujet"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477AA19644B
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 19:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768333441; cv=fail; b=jOQTbtt9s+koBe5aLxHy//DvAAQMo42Kb4PvE4Z+WK1DixkKiSHeAlXdvwxg2R2rzNNXpXdqCT+HNtOBXDIVGQKHD0oaCR+ZCvNV13hYYsPJMKf8PnFkrceZrFB0CwgGh35z//WOKtHJKjratQKBgY4Ap3Pv1nN99fjLM4RAvW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768333441; c=relaxed/simple;
	bh=hIKkcWqBhpCii2Ekdw5hAoR0dCM3r16rTsV5NFqbsRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nPxNvPVmRJTHG7MoxDBC2/Cb7YGrZn7Et1sDTHI5W3OwmT3AjjoUZqCeC+kSk+KQDVrwzCkumABYQTQ3WBXHXFWnbRYV7Lm/U3nBf4tQEjG/gr6/52rrAtveMVEBT6znH6Pj/sGhrcnj76mtARr6ciYtWC2JqmZaLgFQ3bGDDQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=b2sV9fHY; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mEa4ujet; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DJTCB83254389;
	Tue, 13 Jan 2026 11:43:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=QjWP4MvuFCNhulH2laUWr43orD25wVbJCxKGhz0fw
	IE=; b=b2sV9fHYrzaTU9+Zq6G8SpXmh80qVQHkfg8IOHVqzqExiZ9TUeUcFxY6k
	si57euaysNaNIQbec4+r0B3hm+aQifRn+N9s+jMg5/O8BllgDVRI4Thfj0ux1A9o
	KHTCGjJ/Rm2rBpw848YE60nnaDNNFCbgi8gEe74NNoPERMvM5+aNudy0etl2Y1wD
	MEyuT28VOPxPtfmaQiBX4YZr4CpW8xVtT0qvMIVd7D+2US+qjmNLtrm9c7nasQzQ
	G3NqqKs+qT6gp2y6pTihBt6o96aIehQXXA7m8wvGHUM0OwqcnbDSflQfjyeAv++X
	2mJ4LJ0qfvma389fkzKySvz7+CaAg==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020086.outbound.protection.outlook.com [52.101.46.86])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bnne9sdpa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Jan 2026 11:43:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iWWKuDbJfsBm9dgQLJiYbt1BqDqp3prbwhRKfn+0HZ8cbactsswtQQpOtRccdRuQxCPynocc24wxy78lGW0nzs7v2w1VwxHQUh4IaRDfTRwf/X+PYKQ2go8fC55MAYIfWWNUNB5D4Xz2TeFUVeJZv+ndlqVYtzDcNxvDbxNlZUY/INUxpgKiWq7T+ZEysW320pcnJvdAZ/9ZnSgJRK7IRyowxcdGYHd9RIhOy4E9VDvAbkgkstpvM52/TNY5l3VZ7chPJ3XOYGwTre5fYMzL16Vf9jBwiDplMoJPwTzeq37Wi7E+RCBZYiCLicu95aQ7Ccb9BhiTehCV+JSU6QWwQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjWP4MvuFCNhulH2laUWr43orD25wVbJCxKGhz0fwIE=;
 b=Xnn+OuD1+giITR8Lruk2bAA7/dKYn3MUUYxFCWssyCnf+ylIKsMX551vf8z/tpQ+ScUKW0WfXL0HGvqcCBcBRChW8/zJHlDp1rT86oliT7VqtpUBCs969ltMuSbent7/iESREbgK6mtOYFhAPF9Xm3JHeokR0NRZIooxV3KLa3bjsXVmSQeDcIHa+DSQq7vIX0CMxCPPRJffYKrFIumz+ekSbFNtnJe/8FLXTRn0PGcX6mhLWxWOQ8MlgPhyFxv/cqPXJ/QpWFBrttoGqV58oJ3VGbpopLOVt2rPRZ098SCornbILZLha8Qn6ouGqZmPr+DRFToTIS+TswhMVHkWPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjWP4MvuFCNhulH2laUWr43orD25wVbJCxKGhz0fwIE=;
 b=mEa4ujetdVu8EfltOxB5jFjRZq2dH7Vs6ne5gYvaScPDQWrtumevwSH//bc5DKi/8NO5S5WViQ+pOdb6Ly5PoqfQ/EHmIBCXBI40gEeRzRS6xq1uc6PtZJ/f/+baJc7GQOKR1Qjx0FQM1NAtAkVp/Z0SIPppu9ksjWuxiH/msV9UhulFZ4zGTdiX1sAue9cSzYMIIJ3jJM/dxpqtmXS02bdlZLj5VcJ/8xKkE2KGFFKPEvZ6bxG+doJ7waMLdSMKMwbvqX7Vhfba+0vRvAIQjv7UaWeOZMyviCIr8+H7E6Diu5DwAqvlXkLRMMVMqfrGUURDQxSc66U8BrZRmNq8mg==
Received: from DS0PR02MB9321.namprd02.prod.outlook.com (2603:10b6:8:143::21)
 by SJ2PR02MB9922.namprd02.prod.outlook.com (2603:10b6:a03:536::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Tue, 13 Jan
 2026 19:43:44 +0000
Received: from DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f]) by DS0PR02MB9321.namprd02.prod.outlook.com
 ([fe80::16f2:466f:95b5:188f%6]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 19:43:43 +0000
From: Thanos Makatos <thanos.makatos@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        John Levon
	<john.levon@nutanix.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "jag.raman@oracle.com"
	<jag.raman@oracle.com>,
        "eafanasova@gmail.com" <eafanasova@gmail.com>,
        "elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>
Subject: RE: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Thread-Topic: [RFC PATCH] KVM: optionally commit write on ioeventfd write
Thread-Index: AQHcHm7Hwacz3qdkkEq6uKZSQzLqQrT47UsggBaS7oCAAOx5cIAYYdUAgCh9tNA=
Date: Tue, 13 Jan 2026 19:43:43 +0000
Message-ID:
 <DS0PR02MB932134A724D4702B62914DDE8B8EA@DS0PR02MB9321.namprd02.prod.outlook.com>
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
 <aLrvLfkiz6TwR4ML@google.com>
 <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aS9uBw_w7NM_Vnw1@google.com>
 <DS0PR02MB9321EA7B6AB2B559CA1CDFDD8BD9A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aUSobNVZ9VEaLN79@google.com>
In-Reply-To: <aUSobNVZ9VEaLN79@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB9321:EE_|SJ2PR02MB9922:EE_
x-ms-office365-filtering-correlation-id: 295cdc84-ee86-4d6b-1116-08de52dc0f43
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?EnMxiyB55cQUj3chZ9sWBG5v6sbgC20SVHsq+q7MLEjK9yPDsa8XNZVMt+Nq?=
 =?us-ascii?Q?gxYorP3jmj8IhSPrmhcpzaSDC4ft7CNRRg71HKbaWhHgRBcCvulzBON99YQ8?=
 =?us-ascii?Q?dx0dFrRr9xNkypqDVsXt8Z+17d0i4llhFooBPn/VFyZ9Gxb+chJJ4Iv6xNKP?=
 =?us-ascii?Q?foWMdlsi39tp8xhu2U2WfNyEGQAndo9KO3ifw/PFdKd/8IsaRTMlrpEjG/oB?=
 =?us-ascii?Q?5OHjm32Dpr1RH80J1liBXxLsSyEiSsL1RrAVPitRpLwcQ8pGr/sPSfXCKeN1?=
 =?us-ascii?Q?3Nf3/UP569hFS4/+5XGRrKqA6mgs78DLxhY0oC34XyX26zvnmSoc2YnsyIEm?=
 =?us-ascii?Q?gHk1Ofodv0LIjHAShDYHfRcZekVzIAKdn6GnUUhbfegCK8kM7taca5R3T0Hp?=
 =?us-ascii?Q?paOfpOLkJ+hcftyZ6avCBhESl3ZavuFysq0jI+TJ3syBoiXDHaL4jxzMPOvM?=
 =?us-ascii?Q?VdFFidFRqf2OaL1p+YDdOr/pIPfpcsThLCAfxbZikxOowT1T0vOAF7EI7ffP?=
 =?us-ascii?Q?Xgi+RFLHKqTpDOL19uEczG6s+UtKQIpp9dQ+GQ2qYYLfBOGKo37eKNaXgCLm?=
 =?us-ascii?Q?4Cn0lfxfNi76F6Ar46MEhGxqvddqK/7b9Iam0uIAVOCQtt27F7zsmBZJikXr?=
 =?us-ascii?Q?42HwA4F6tWeCM3AWZc7s+gwy1MrcdyzS9lsJ87+5bQh7QB+H2n61uekR4vmn?=
 =?us-ascii?Q?i1KEm/m+CspcqQIvwlgTb3vg7bEqGEN6pNE+XjoHxis8wVBzozJvkJ0L4j9K?=
 =?us-ascii?Q?31E+XMidj5tz9G/fQzUXUc5BF9lWLHOv7zyTUrrvKP+U3e04OHU9Y7rybEA1?=
 =?us-ascii?Q?mN8eAKEzuMg2o9B09oX3GeCrCtx3MIlT4ZXZSmUyUFFJvFmpqgjXDyO1bmXH?=
 =?us-ascii?Q?+Q2/uO60e2nj0u24H8+MLzt0Zh65Jhlrl2PAooj5kDlVS7GHMbGPg2TaL18h?=
 =?us-ascii?Q?fVatB+UK2zQmDeY+EV5ZXKpTgtjeypUq3eNIar4IWppePqYwLXfp/nGI305J?=
 =?us-ascii?Q?0PveLKupoVFaQHyQPI8Ts+Ykb9qxtUn8nW1nDhoCGjpIXgK7gYRe050IHDaH?=
 =?us-ascii?Q?FG1danF6NzuIYAN1EUtxJ0eGn/0EA6kFN3T2u05tbhuxKjsraFb4hHkTX/J1?=
 =?us-ascii?Q?3pfieqQuaN2+VZzcneqFa8/jZgKzrIDD6THz1asymk9SuqNMgKbZLlkdVlC6?=
 =?us-ascii?Q?/r/ruIre/PhUNU38cPyoDCHxBZklAHfdIJ2wZnLTrK9DgsnJLgCRn32Ej0Ih?=
 =?us-ascii?Q?1fJeXYCEJ+gfVAmu5697CkK0MF0cvhlIWsFc72kBGm8uNL0EK/agBmTeCxdG?=
 =?us-ascii?Q?A17tUlQo7i5J/pqxWoQ2Qy8qZNXEJGtHpIRtGIG57zTXxPG94DYJVVcvi5Nw?=
 =?us-ascii?Q?QRe/OnxVtLdpGx3i3iwxuP7x6Pahn3heUSEeDSe63e1my2HV/9fOiTyAqZ9Z?=
 =?us-ascii?Q?1G3yp8ytd6d8kyCXBCROgVElCcQD28ym4zBKFKN5cbSoNrTCTENj6m326d8Q?=
 =?us-ascii?Q?Yidl9bkXKOSRKwt40POSUyd6BoG5WZxvhLU6?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB9321.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XR/tVFjaXu0YzGgpE2NOKMnmq8jDukCA/cvpt980kM7qVV+iN3CC57ikReJ7?=
 =?us-ascii?Q?Ls3dkb6hxfNCT9N1yMrgqQA89YbYLVnbJqkIPN0hRNSX5opJ93+F1vVWdqtZ?=
 =?us-ascii?Q?WDKF74lwFVK3uc0NStoYMP4Q6/L/G3Y9dHVpUQRab1nFcK9Jf2Im1pYPjFeR?=
 =?us-ascii?Q?Dd/n9sSXirJBB6Vq/wlvAJofM8dFBtBwFYo//0Mum5CA+WW7DW39V9K6yK3P?=
 =?us-ascii?Q?kJCvwDYWC2XZsffWB5d/fHkI3I7VR5fd/GeRcx9Epx166DnpbUQTiuwYJKmu?=
 =?us-ascii?Q?eUDieNZ2WC/lpGnRP0j56dGXVZXHv0vmAUMhkxSgJG1X7qNvnqjQYIoPf7dU?=
 =?us-ascii?Q?YsspOzSjFvvYSa1HuIZIuD/IaEdh6tbjReEx2v6p1kZpVWc9mU0vga6alAGv?=
 =?us-ascii?Q?AXywRw09dfqSgS3a9w2czguCqYbB8oO9As/p4K1/rGrpOgcgGgGXsQF6pGzM?=
 =?us-ascii?Q?jWJLa6lwDHXEXHL5KbNz7afxAqgiVVI6fzq/8C5+mtXghIfSaSKEq+RgHQM9?=
 =?us-ascii?Q?xXVz9HOmrxGPVmxFRWV2mxGozVJMzE1NL4DzNcThWwxOTXQDvwSMiuxI2dRS?=
 =?us-ascii?Q?Mf7wGjRBQHESR8deoNOpd2LmbDkeO4HfmcW4cDgcsH6oOWg4Zlhdv6INsDsR?=
 =?us-ascii?Q?F5mgcHpLeSq+u3K3xxnR/1p3tSUPNC7UVMtNQCKDUFnxURBbEvSz76WYJMwF?=
 =?us-ascii?Q?pAOBuVv6YQVX+4nrwuuMMlxzOBwEkIVh/AY+aAPB0Ihs66GWKy2b8t4jOpjr?=
 =?us-ascii?Q?WZokFSkDvnKDWUN/qh5J21gObbaptnqDX1zcmDp+Qq5fBzEMjvv9xZqBdEXn?=
 =?us-ascii?Q?eHoe0kqE38F3i0Bjk0jOHg8DkDtiXexW7rzunzQWI6M2ltknclthv7KVIkOA?=
 =?us-ascii?Q?7hcXzMiV4QdBzPg7H9yF/IRZWIwFVXxeHCqaeXiYM3E+U5PdnY5UFzRMwems?=
 =?us-ascii?Q?n+O2q0nplYHqd4Ay4040zS+DrEUQvFHL294HlE0mYRlEAWNlQQX9E7ChkL3T?=
 =?us-ascii?Q?dI0vXtKO4pBMZYBspWFXSc9AhmJnOebyLWjMYCJmqHTPEKMlMRV47JSae1au?=
 =?us-ascii?Q?YAUDUDUwCePd3hVsrtGq6lgQUGQBbdnqcUZxbP/kVLecKg+uNPEsJ+f/pTR1?=
 =?us-ascii?Q?7b94oIVDJCcjakwTJ1J9u3WlqZhClPUKE/BYGnuWW+ZW/jDch2LDeBwQ4h2t?=
 =?us-ascii?Q?Z+Kfmsf6wPtBRtEnf/htx5yc00jNi0nazaxa0dCFkIOw5d8a/EZv9UJwGIZi?=
 =?us-ascii?Q?LM9SfjHgyf/qUyID0gCdt7Y7vUDMdQ3BSHGicyiaxGIX+txvjwB4s67OL9wJ?=
 =?us-ascii?Q?JYnb9Y+Zj7anc3guISCGR1n5qkzfh9eFNcRDZxyY9Wk7hm19Nf2+wQLTMWas?=
 =?us-ascii?Q?JNcyu9PuheWMTKc91nxpxIpUSS7Tbkp1IxytQ0NsR+nt9oygnu67DBXzzSD5?=
 =?us-ascii?Q?p2Yq1+E2mUbhlrJzR+4k1X1vHHHgUU8Z4Sr8IrSRRIexbhTdfgCPhzDq5e40?=
 =?us-ascii?Q?taC5qCHQDQTvA0fYtZ0X8GwetmSFii+VOYrA55NGWE4xVj3BoBV9oVZuKyDZ?=
 =?us-ascii?Q?X/kNWbom2k2fa0NXvumJotqj5bxgOhpjgmAaRMtyef8Hyty/cI37s9YfkZI0?=
 =?us-ascii?Q?oFJdaNm92hMi382HLhJpt7DmZXcm6ky9RWVs6pfes9rsnbWRygY5//zXgQ+e?=
 =?us-ascii?Q?EQUniCHlC4Os4x8zfzO+izhHlzXQlmSMQXATvncKGp10l2ACGSUpqt0QKdpC?=
 =?us-ascii?Q?Iw2SK3gZqg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB9321.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295cdc84-ee86-4d6b-1116-08de52dc0f43
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2026 19:43:43.4783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sb90JILWsO/YcASwBMOYzc+jbsSAH3fGvzr8As3tGjPzHs1ePyxEehTadXBk9TnEZpG0gee77XclBuAbBE50RMcWeQlB7rCDsDiFGIBauRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB9922
X-Proofpoint-GUID: cyC4tYtXesAl5yF2bUf9uPYHEOdEDjGp
X-Authority-Analysis: v=2.4 cv=DoRbOW/+ c=1 sm=1 tr=0 ts=6966a073 cx=c_pps
 a=FJjcbeYznbroKK2DnCisOA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=aG8_-aLGxvYk6x5u0K4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: cyC4tYtXesAl5yF2bUf9uPYHEOdEDjGp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE2NSBTYWx0ZWRfXywASt+aGFx15
 EjAr1zXvUZDrj/gMVIhlqXURf9tZrxG52IgwUZ2WGyX05fKsgo67J0hK8+GrZ1n3+fjzQ1LLcuH
 Jxxzm/3keeZ+KhxNvXyRzFm8qSjSyJ43O0OeN33OCU4ytRNuEz/86RMaaJ/d8DcYO/+hh+Rx3s7
 t131A+KPycQpoMwWrcXz9DVtpw8ctlM9U/ps9rpvPUb086hVusJAiWk7Dl8ApGTozptOZqOaNvF
 N0iHqSla6LOpDDk3g1xieZBM4B0ONTRhBeCkgIh3SMw+FcJ9s3iOb22jBoAmm5A+pYJKkVXZBGz
 6GFDmJLyoKlA2v0i4Lxf/rIoDgs4d82misMBzSm3Zxv3VEcfPkoQSx5pNl5WOYVS13NgCc3MkNR
 SZeZM6b8tbqduxqADFrqeVda/MbMnJYcoKHhMxopMTXDLwG7TAiYuLcaxDu2Sc40VV5w1J2Mz+M
 ZpsoeSNtN7LkJt1DniQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: 19 December 2025 01:21
> To: Thanos Makatos <thanos.makatos@nutanix.com>
> Cc: kvm@vger.kernel.org; John Levon <john.levon@nutanix.com>;
> mst@redhat.com; dinechin@redhat.com; cohuck@redhat.com;
> jasowang@redhat.com; stefanha@redhat.com; jag.raman@oracle.com;
> eafanasova@gmail.com; elena.ufimtseva@oracle.com; Paolo Bonzini
> <pbonzini@redhat.com>
> Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd write
>=20
> !-------------------------------------------------------------------|
>   CAUTION: External Email
>=20
> |-------------------------------------------------------------------!
>=20
> +Paolo (just realized Paolo isn't on the Cc)
>=20
> On Wed, Dec 03, 2025, Thanos Makatos wrote:
> > > From: Sean Christopherson <seanjc@google.com>
> > > Side topic, Paolo had an off-the-cuff idea of adding uAPI to support
> > > notifications on memslot ranges, as opposed to posting writes via
> > > ioeventfd.  E.g. add a memslot flag, or maybe a memory attribute, tha=
t
> > > causes KVM to write-protect a region, emulate in response to writes, =
and
> > > then notify an eventfd after emulating the write.  It'd be a lot like
> > > KVM_MEM_READONLY, except that KVM would commit the write to
> memory and
> > > notify, as opposed to exiting to userspace.
> >
> > Are you thinking for reusing/adapting the mechanism in this patch for t=
hat?
>=20
> Paolo's idea was to forego this patch entirely and instead add a more gen=
eric
> write-notify mechanism.  In practice, the only real difference is that th=
e writes
> would be fully in-place instead of a redirection, which in turn would all=
ow the
> guest to read without triggering a VM-Exit, and I suppose might save
> userspace
> from some dirty logging operations.
>=20
> While I really like the mechanics of the idea, after sketching out the ba=
sic
> gist (see below), I'm not convinced the additional complexity is worth th=
e
> gains.
> Unless reading from NVMe submission queues is a common operation, it
> doesn't seem
> like eliding VM-Exits on reads buys much.
>=20
> Every arch would need to be updated to handle the new way of handling
> emulated
> writes, with varying degrees of complexity.  E.g. on x86 I think it would=
 just be
> teaching the MMU about the new "emulate on write" behavior, but for arm64
> (and
> presumably any other architecture without a generic emulator), it would b=
e
> that
> plus new code to actually commit the write to guest memory.
>=20
> The other scary aspect is correctly handling "writable from KVM" and "can=
't
> be
> mapped writable".  Getting that correct in all places is non-trivial, and=
 seems
> like it could be a pain to maintain, which potentially fatal failure mode=
s, e.g.
> if KVM writes guest memory but fails to notify, tracking down the bug wou=
ld
> be
> "fun".
>=20
> So my vote is to add POST_WRITE functionality to I/O eventfd, and hold of=
f on
> a
> generic write-notify mechanism until there's a (really) strong use case.
>=20
> Paolo, thoughts?

In the absence of a response, shall we go ahead with POST_WRITE? I have the=
 revised patch ready.

>=20
>=20
> ---
>  arch/x86/kvm/mmu/mmu.c   |  6 +++--
>  include/linux/kvm_host.h |  2 ++
>  include/uapi/linux/kvm.h |  3 ++-
>  virt/kvm/kvm_main.c      | 51 +++++++++++++++++++++++++++++++++-------
>  4 files changed, 51 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 02c450686b4a..acad277ba2a1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3493,7 +3493,8 @@ static int kvm_handle_error_pfn(struct kvm_vcpu
> *vcpu, struct kvm_page_fault *fa
>  	 * into the spte otherwise read access on readonly gfn also can
>  	 * caused mmio page fault and treat it as mmio access.
>  	 */
> -	if (fault->pfn =3D=3D KVM_PFN_ERR_RO_FAULT)
> +	if (fault->pfn =3D=3D KVM_PFN_ERR_RO_FAULT ||
> +	    fault->pfn =3D=3D KVM_PFN_ERR_WRITE_NOTIFY)
>  		return RET_PF_EMULATE;
>=20
>  	if (fault->pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
> @@ -4582,7 +4583,8 @@ static int kvm_mmu_faultin_pfn_gmem(struct
> kvm_vcpu *vcpu,
>  		return r;
>  	}
>=20
> -	fault->map_writable =3D !(fault->slot->flags & KVM_MEM_READONLY);
> +	fault->map_writable =3D !(fault->slot->flags &
> +				(KVM_MEM_READONLY |
> KVM_MEM_WRITE_NOTIFY));
>  	fault->max_level =3D kvm_max_level_for_order(max_order);
>=20
>  	return RET_PF_CONTINUE;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d93f75b05ae2..e75dc5c2a279 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -99,6 +99,7 @@
>  #define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)
>  #define KVM_PFN_ERR_SIGPENDING	(KVM_PFN_ERR_MASK + 3)
>  #define KVM_PFN_ERR_NEEDS_IO	(KVM_PFN_ERR_MASK + 4)
> +#define KVM_PFN_ERR_WRITE_NOTIFY (KVM_PFN_ERR_MASK + 5)
>=20
>  /*
>   * error pfns indicate that the gfn is in slot but faild to
> @@ -615,6 +616,7 @@ struct kvm_memory_slot {
>  		pgoff_t pgoff;
>  	} gmem;
>  #endif
> +	struct eventfd_ctx *eventfd;
>  };
>=20
>  static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..c3d084a09d6c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -39,7 +39,7 @@ struct kvm_userspace_memory_region2 {
>  	__u64 userspace_addr;
>  	__u64 guest_memfd_offset;
>  	__u32 guest_memfd;
> -	__u32 pad1;
> +	__u32 eventfd;
>  	__u64 pad2[14];
>  };
>=20
> @@ -51,6 +51,7 @@ struct kvm_userspace_memory_region2 {
>  #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>  #define KVM_MEM_READONLY	(1UL << 1)
>  #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
> +#define KVM_MEM_WRITE_NOTIFY	(1UL << 3)
>=20
>  /* for KVM_IRQ_LINE */
>  struct kvm_irq_level {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f1f6a71b2b5f..e58d43bae757 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -953,6 +953,8 @@ static void kvm_destroy_dirty_bitmap(struct
> kvm_memory_slot *memslot)
>  /* This does not remove the slot from struct kvm_memslots data structure=
s
> */
>  static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot
> *slot)
>  {
> +	if (slot->flags & KVM_MEM_WRITE_NOTIFY)
> +		eventfd_ctx_put(slot->eventfd);
>  	if (slot->flags & KVM_MEM_GUEST_MEMFD)
>  		kvm_gmem_unbind(slot);
>=20
> @@ -1607,11 +1609,15 @@ static int check_memory_region_flags(struct kvm
> *kvm,
>  	/*
>  	 * GUEST_MEMFD is incompatible with read-only memslots, as writes
> to
>  	 * read-only memslots have emulated MMIO, not page fault,
> semantics,
> -	 * and KVM doesn't allow emulated MMIO for private memory.
> +	 * and KVM doesn't allow emulated MMIO for private memory.  Ditto
> for
> +	 * write-notify memslots (emulated exitless MMIO).
>  	 */
> -	if (kvm_arch_has_readonly_mem(kvm) &&
> -	    !(mem->flags & KVM_MEM_GUEST_MEMFD))
> -		valid_flags |=3D KVM_MEM_READONLY;
> +	if (!mem->flags & KVM_MEM_GUEST_MEMFD) {
> +		if (kvm_arch_has_readonly_mem(kvm))
> +			valid_flags |=3D KVM_MEM_READONLY;
> +		if (kvm_arch_has_write_notify_mem(kvm))
> +			valid_flags |=3D KVM_MEM_WRITE_NOTIFY;
> +	}
>=20
>  	if (mem->flags & ~valid_flags)
>  		return -EINVAL;
> @@ -2100,7 +2106,9 @@ static int kvm_set_memory_region(struct kvm
> *kvm,
>  			return -EINVAL;
>  		if ((mem->userspace_addr !=3D old->userspace_addr) ||
>  		    (npages !=3D old->npages) ||
> -		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY |
> KVM_MEM_GUEST_MEMFD)))
> +		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY |
> +						  KVM_MEM_GUEST_MEMFD
> |
> +
> KVM_MEM_WRITE_NOTIFY)))
>  			return -EINVAL;
>=20
>  		if (base_gfn !=3D old->base_gfn)
> @@ -2131,13 +2139,29 @@ static int kvm_set_memory_region(struct kvm
> *kvm,
>  		if (r)
>  			goto out;
>  	}
> +	if (mem->flags & KVM_MEM_WRITE_NOTIFY) {
> +		CLASS(fd, f)(mem->eventfd);
> +		if (fd_empty(f)) {
> +			r =3D -EBADF;
> +			goto out_unbind;
> +		}
> +
> +		new->eventfd =3D eventfd_ctx_fileget(fd_file(f));
> +		if (IS_ERR(new->eventfd)) {
> +			r =3D PTR_ERR(new->eventfd);
> +			goto out_unbind;
> +		}
> +	}
>=20
>  	r =3D kvm_set_memslot(kvm, old, new, change);
>  	if (r)
> -		goto out_unbind;
> +		goto out_eventfd;
>=20
>  	return 0;
>=20
> +out_eventfd:
> +	if (mem->flags & KVM_MEM_WRITE_NOTIFY)
> +		eventfd_ctx_put(new->eventfd);
>  out_unbind:
>  	if (mem->flags & KVM_MEM_GUEST_MEMFD)
>  		kvm_gmem_unbind(new);
> @@ -2727,6 +2751,11 @@ unsigned long kvm_host_page_size(struct
> kvm_vcpu *vcpu, gfn_t gfn)
>  	return size;
>  }
>=20
> +static bool memslot_is_write_notify(const struct kvm_memory_slot *slot)
> +{
> +	return slot->flags & KVM_MEM_WRITE_NOTIFY;
> +}
> +
>  static bool memslot_is_readonly(const struct kvm_memory_slot *slot)
>  {
>  	return slot->flags & KVM_MEM_READONLY;
> @@ -2786,7 +2815,7 @@ unsigned long gfn_to_hva_memslot_prot(struct
> kvm_memory_slot *slot,
>  	unsigned long hva =3D __gfn_to_hva_many(slot, gfn, NULL, false);
>=20
>  	if (!kvm_is_error_hva(hva) && writable)
> -		*writable =3D !memslot_is_readonly(slot);
> +		*writable =3D !memslot_is_readonly(slot)
>=20
>  	return hva;
>  }
> @@ -3060,7 +3089,11 @@ static kvm_pfn_t kvm_follow_pfn(struct
> kvm_follow_pfn *kfp)
>  	if (kvm_is_error_hva(kfp->hva))
>  		return KVM_PFN_NOSLOT;
>=20
> -	if (memslot_is_readonly(kfp->slot) && kfp->map_writable) {
> +	if ((kfp->flags & FOLL_WRITE) && memslot_is_write_notify(kfp-
> >slot))
> +		return KVM_PFN_ERR_WRITE_NOTIFY;
> +
> +	if (kfp->map_writable &&
> +	    (memslot_is_readonly(kfp->slot) || memslot_is_write_notify(kfp-
> >slot)) {
>  		*kfp->map_writable =3D false;
>  		kfp->map_writable =3D NULL;
>  	}
> @@ -3324,6 +3357,8 @@ static int __kvm_write_guest_page(struct kvm
> *kvm,
>  	r =3D __copy_to_user((void __user *)addr + offset, data, len);
>  	if (r)
>  		return -EFAULT;
> +	if (memslot_is_write_notify(memslot))
> +		eventfd_signal(memslot->eventfd);
>  	mark_page_dirty_in_slot(kvm, memslot, gfn);
>  	return 0;
>  }
>=20
> base-commit: 58e10b63777d0aebee2cf4e6c67e1a83e7edbe0f
> --

