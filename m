Return-Path: <kvm+bounces-68659-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDtmJtAFcGmUUgAAu9opvQ
	(envelope-from <kvm+bounces-68659-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:46:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 280A64D352
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:46:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AE3FDB2248D
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE1D3A0B20;
	Tue, 20 Jan 2026 22:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ONs+SGUV";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tkXsS0ai"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B923002A5
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 22:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768946459; cv=fail; b=DPtuUaLXpf5tKsb4noOdLU2vj4uWYVQpI4HF6+lolkcM7IKj2ChWvQe2ioGd2TS4gM5F8VrklCkn4W95ykJha+s7W5HHGwexWiS/+QC4zmtI2yB/4WbcPBzMGG7pnOK7rQryAQABnoDsqfmYnRtp0vTfNRYq/Z4X3utNDZNELgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768946459; c=relaxed/simple;
	bh=+Fis2bSKSqcuM06Ri+u28XZviMStG5LYxMvNdRmGIpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mj1NQE4YJFkfV1lCfwiGjZ4HnZDHJNnD5nrHEcVqSBG2S1vcBnI/6rz407v5LEVue02bBCMNYpO1WhhPbso7ZPLo+Cfvvqfuy2TAPLfE9O31Du8yDUZxzpCvckq+XsD1UtyAeCWTWan9dM6BWAcEHSP3HLZSfU/BX5U12+sfUck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ONs+SGUV; dkim=fail (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tkXsS0ai reason="signature verification failed"; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KGe2Vm3650824;
	Tue, 20 Jan 2026 14:00:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=EA7s+G7hy6EZclM3miDqxnK2nzWSAShnAHT92y9vv
	Gk=; b=ONs+SGUVRnchhfNlUzxioy2O71yWjTNJyPLXpOYdBxnS6p7MLOMspoOVm
	MW11Ueo6kz14cHA7m3ArqS04axEaOmh12PQ0Mya67kZgiAv9K4ZaopUiPvGKMNXk
	1IQ41wBkLEqiG8sSE6UgmThMJLhqaRbFpLC6+ChZ7gG3simD40qU3MOL4zSH1/a1
	j6nSS3kKXVYFNlxMkmJKKj9M59WhyUlUanQOyk8GDDsdGCvH+CQQZShGY/qApPWK
	D4xrc7qboBEQZiGpURnemb02j6NlV5tWubCCYWsI8y/MOlk55q7FJFcG7Ux9XWI8
	mwzZ4T2T9pdrADu5g67UDHPROZGGg==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020090.outbound.protection.outlook.com [52.101.193.90])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4btde7rrxs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 14:00:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I1ZyxsBFBcSxBzMyxqp/sVWJzxLdvJ5qkhBqsMps0xb665uv+FLV4wM/hLyHx47H4b3TVM9u1HXemBMCt5+AMPEjgvaq9z10aUg76wgnOUpqSZGk+3hujSYp4ShgFtu2r491AxA7BTIA2ZL4o1+CLUGQMRoke1jwpMXyhZ3uPsSs6lo+8Ewk7dkzkj6Gx0+e4Z02K8cvNmTpbhJYqAuH9F6ptUBEnKVqbblBlfAeSgtpICw5PN6M9gupERdlA2iiGKgObQvUAAk18jMSaXMgr9kSj2leLnPeLWBshGLqsdpWhFiG/6QUdE63ej0UQBjh3FIHF7tLcm2mnsyWOcgEiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Da6TLMwajA/85+QO6pYeHvhKdoL0FRoJQzWpynnDHp8=;
 b=Jb1nCl8RuaakPtn17UZHEfAko+1yPGnmXjTCcO7kxlrDC/mkNxYHDpQHekvFkBk+Avmh2Z5HsWufoNRUY0fibQ5TWTy0bq7MmpTKofeY84AbX7c7L1xyOjAm6Ja7LITTyhdJhGrlsJ45fDYC0FD2GidduluHvxKyrOYaaIuxK9ZQgMse3VGT/n2FBAHlwswk+7BUhgTy4YDi3ssozv18cxFakf6tPlhs39wxtfYTYp1bngey1ONfGxbTSiSUFxKgoAqw9z7GLFSDvuXG0fdG6YbkIyJt02LqIpDINFEJIXbBae7Vcf3JNkI/mKPW1I9EACkgqSyLggH7t5eOjMizSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Da6TLMwajA/85+QO6pYeHvhKdoL0FRoJQzWpynnDHp8=;
 b=tkXsS0aiU/2d7Q2KhnTaQKeF6bUXpRoWMxp/9DAFHYCq/otivXnUwj83NeqnioHnZiJKN+q+jBR3b07F+sfGQnEUXtCaP9rtliRQJmnQkMzS/kwpXGoi+RqOjrW0+GCLp+3NkTaLjcqFgE5KppyG/yAcjUB4dKGxHnlivU3Fy1marruVjfxnMwZOERFwm3g1yJ7vrvNXN1FEn/RAkAJm1zD6F2uuHRE/F2PuZwoiuIkaOl6Hu19Y5rpbYxOcVskIVdRhQJ/G1EC+GHT4+etcHMAQVLuBNt8j4XHDHvInAbuOmopFE8PJ/OHGp4Rp8whSmTgl1BOvnGAxXb2OGuvvnw==
Received: from CH2PR02MB6760.namprd02.prod.outlook.com (2603:10b6:610:7f::9)
 by CO1PR02MB8460.namprd02.prod.outlook.com (2603:10b6:303:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Tue, 20 Jan
 2026 22:00:18 +0000
Received: from CH2PR02MB6760.namprd02.prod.outlook.com
 ([fe80::dbc1:9766:c58d:4887]) by CH2PR02MB6760.namprd02.prod.outlook.com
 ([fe80::dbc1:9766:c58d:4887%6]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 22:00:18 +0000
Date: Tue, 20 Jan 2026 22:00:10 +0000
From: John Levon <john.levon@nutanix.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, German Maglione <gmaglione@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>, danpb@redhat.com,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Alex Bennee <alex.bennee@linaro.org>,
        Pierrick Bouvier <pierrick.bouvier@linaro.org>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <aW_66oESlTmzjCCC@lent>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
X-Url: http://www.movementarian.org/
X-ClientProxiedBy: LO4P123CA0633.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::20) To CH2PR02MB6760.namprd02.prod.outlook.com
 (2603:10b6:610:7f::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR02MB6760:EE_|CO1PR02MB8460:EE_
X-MS-Office365-Filtering-Correlation-Id: a4cb399a-09ae-4ae8-7b13-08de586f4cbb
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Njz27lhCNZdhJCXD9bWuXmaxh+T83/9h8NcKraC1pmMvsVwSN/x2BfX9R8?=
 =?iso-8859-1?Q?5YHIlrVpaCS5uEp+Q/hg5Yojo/zYrcZgYJASXXKvFU46Rd4miB5duusfR3?=
 =?iso-8859-1?Q?8ZxhQWm5MPJlv423j7Q7klUrfraMpZRkfo5nV3TymlrhfPJ16RZAz1LEHL?=
 =?iso-8859-1?Q?KiG1gM6d4iJlrkGyg8yfGPUlGOvDtR2AALl2atlaGbIG9mxw+W/3n1ipsK?=
 =?iso-8859-1?Q?SfCZmNM0ecKsEUbzUtNAPfNs7Lmy7FZLu7LKhxvXsfngca9iOKPzw+rN38?=
 =?iso-8859-1?Q?AdegajwWorwDBhKJ3s07kFma8MYAGEt5P7aOvNSfGyXfGGd44yxQjOFqss?=
 =?iso-8859-1?Q?TkbSSuc46rgtXFqQcGXp47Ztv78yl5zTxMV53I3Ys83/Wn74h0K3uK59zT?=
 =?iso-8859-1?Q?5RyuEeXBAugYRuc1ajRXk9m3rmhEJW97JeT3I7mK/6bQChICLAKrDzpH3b?=
 =?iso-8859-1?Q?EXptfn51OPk8UICNICU0yRaAILd+YA3ngbAztPP9sgrsnZXQGyMgTX4yjI?=
 =?iso-8859-1?Q?21WKt9s65EYWwq9nEZ83ihW5SGPDlJDbxAjDAqnOhWcgO/6fQYQpqOp49+?=
 =?iso-8859-1?Q?yZZaft5H5+WpD7tRNASbyAKB4r5dcllV3hctkcMgW7zMa2ODuQZWeC0qAT?=
 =?iso-8859-1?Q?i+36qWW7q2/LK7zhEoTFDkK2KYN+41qDvJMx8vRA+2W2E8BJgfDyaQbP1M?=
 =?iso-8859-1?Q?Q5jpUpeynX4/CS15lBusAMMUthQlz10MhCRJZXhPaUCktFa7jiqqkGSNDj?=
 =?iso-8859-1?Q?2EfXFToJzun6JgQNOvajQDiHaFoLrYsPI6nnCZuZ78CXegr8SL3HIhlYHX?=
 =?iso-8859-1?Q?x/O8zwDJoK/kZPCit0y22aGM6vS0HxkAIrwvz4qWxXTp2YMR8eHhN7dFA+?=
 =?iso-8859-1?Q?jmFLiSCHG4S1KVWWMTbH4in0Ti7lTMKSTRUd+qAQL+A/BvTssZSkWqq6xy?=
 =?iso-8859-1?Q?jbwvCHk+AfE12hwVVHoZ4fQnTx4xfMYetCLxgrR5AeX9g9jSyWb3xVtuSJ?=
 =?iso-8859-1?Q?+1YyaLDVxVZiGmv/gDcMe2asl/fUdIBV2WDACuJx8iGy8lahsVcWou/OS4?=
 =?iso-8859-1?Q?lK5wguV+peBxecMNuHq1WmyfCL4vesNYERA3yhxA7ia2e8YMyCqnZYOxnX?=
 =?iso-8859-1?Q?Q2zyurLZe6vuPsyuf1fAPGXm5le732emXw1BnyfjNu2ljEJw813YMnt7r8?=
 =?iso-8859-1?Q?5mrCyIJ9dt8m3cC6NLONes2G9x08EZiM0wxRh+sPZDZqSP6oE2XgVIk9OE?=
 =?iso-8859-1?Q?RFZfJe9/nIRrIWbAqV9PEztExm7tlqyUy6xsQh8NsMWQFsugDvD0/SsWgP?=
 =?iso-8859-1?Q?HTEYYbBMIQCYUfF/SjO50WeK7p6OeJIHTi1hZOUwsBr1HZDmBYLtmRj/wQ?=
 =?iso-8859-1?Q?8FekUArbKqAJd8eyWBt6WQwJPK/ONxb9sdlXZNbkm03lADOJwpe2wPgrdX?=
 =?iso-8859-1?Q?i0ygYRxFFxoTHEcYf/D42xSZ+DBXYUIWPF8CziXmSccyJqxafr0Aee2PRi?=
 =?iso-8859-1?Q?Y626JhgpqYG1DNpEeMOisoB6fdDlvgsv8xeoix1o45nGuFsokKrotNMzeX?=
 =?iso-8859-1?Q?Lon2Ac4hsL+1/tiSHkrBqREuceUABnd53gZ7HDeOX+wSwHIwQk0ipkGNNE?=
 =?iso-8859-1?Q?bcYY9mmVUjE8U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR02MB6760.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?JO7wNwGTNdYQUpDsSjGSJ1MrnDc5l8GDaPxMduW20l27u14xNZF1LtpS1+?=
 =?iso-8859-1?Q?xpU/3CC/8spL27l0siTlPh0uBC0KEjFcFh0D2sgWHTlxwT2nUPYcE3p0Be?=
 =?iso-8859-1?Q?5YSpLlUczZYpHQkdD5GqbKcKheMTfkNH0gpNPpq9mBshYePP8X8qnQGu7a?=
 =?iso-8859-1?Q?v/g462U+rciTAExYFhwpFbzClsU+EWgROP6PG7qL/J8mA0gKCSTWegWvAM?=
 =?iso-8859-1?Q?FNLcgldxDPKMEz5PHhc7Ig+7+wRzAyxkRyK+IIbDJ2ThyfaGzOTtmzOHda?=
 =?iso-8859-1?Q?fkGaDNbHhyYit6MdbIehwaC4mOiBuvSrmKSMsYKloGCazSy3s9XwLgcJXI?=
 =?iso-8859-1?Q?iVHt+iLvSQ0u88ZBTyeGk7HOMwD5OvrqV7auH+DlF64R1g0GaFhgv2OdEH?=
 =?iso-8859-1?Q?VUau4YZLMkwna7tkxWOqqruPKySdbfMuD0Z/VwT6EVpUX6kupwGsTG91J4?=
 =?iso-8859-1?Q?5Pck3aFpTrSwXkWh8u9X+QzWMhxE0wR1+23AHwHSkL3IAjfnV9t/Z5YCKF?=
 =?iso-8859-1?Q?7nfKH3VxID/ouI6aOOfAxYYVciRE9CM9NOHi7Mq6lmSq4C+nuZuWp7XEoW?=
 =?iso-8859-1?Q?N0XmGhO6w1v8nC+EqMDpKMPKdzGBNM7pcdEQYRziRh/0tn09ehASUlozSK?=
 =?iso-8859-1?Q?rLB/vFSgSVBBVFvrtGO5yyOYhdhSWrtR2XN00ePNsnEYjd4DKMTtcOkby4?=
 =?iso-8859-1?Q?BMA3tgn+mBlkFt3USwq4DdPEbRSf1CLnKpZQSAw9SCQAk7jgAogLAbN6e+?=
 =?iso-8859-1?Q?Rm/L8Febp6qJI/08b0caTSG9yQdtJP4jbWGRNzmagGTUcCR9pC/fTDGsmt?=
 =?iso-8859-1?Q?AdycHsO4aE1Y+ptxV25BgRI/nzMQI7Dby4sXKcbXr9Wui6F5NNAtEjrgfW?=
 =?iso-8859-1?Q?raShHZcIBvYgzdzcn9erw8GjcFAGm13ulPoafpNzU2CNl4wHC4l4X7ejeG?=
 =?iso-8859-1?Q?WlaQGH0OWonjYeC/oAmOI5xFByafPMeWNKXo56UCBoudX1ohHGXcv1wzS4?=
 =?iso-8859-1?Q?7OrAbpwMrMe4E+pTdfiBbl9C0AGi8tvzFTO3PEsDxdYUs/1QGmLF2VN1zr?=
 =?iso-8859-1?Q?4yi03LD4bQCay0rqe8JVyWbbnzgyO4gYqkqYdJSvZ/i+eWCHU00xm3+wyQ?=
 =?iso-8859-1?Q?GrMeb0rbFy5eKaIZgAqgDirmLoL39cmRsOY4KCzOe4rzvaNHWg2ZzRoUwQ?=
 =?iso-8859-1?Q?1TBhSCbFak34hgw9y3YzlQ6pCUnMQko2ifbgLZQGdkMd46b7VLEd22SuUM?=
 =?iso-8859-1?Q?FgS8EI5bN2rGLBXKI4qA7wRXklO6aLlIvcBFxsgVK3xMxjR/ybqZXeDA80?=
 =?iso-8859-1?Q?NTL4rcnyciR7RBdwikKTX137u35yyjY5Zm7FRpnQ7n0CP5Wy08XkQ7s9ql?=
 =?iso-8859-1?Q?E15yWnA3gpeLoN3tCZ2112LbbmKWrzjyYFHuWADmg4JXvW89rQlX7j8cdY?=
 =?iso-8859-1?Q?lAIbhdIjnlvJH34O4nyyb3KL5EqznsaiYXplfsuotH/G1lO1/cscEsjD6m?=
 =?iso-8859-1?Q?ibOb4BhCkgF5Nz1RXLAfAGqeq3dYKUMPhArxU+DDj6TmB4NloDvk9la/ze?=
 =?iso-8859-1?Q?QTxm2ymtfuK3mEJfqa0ZRxVGe7tm0ZnxQ7N7tImnzluuHqgfX7KDu6ib4v?=
 =?iso-8859-1?Q?W+zLr5o6U53tKzBT24PjPouWJA8aJa02TvWHrYkhzXDUCWCYDxXXg2JvB9?=
 =?iso-8859-1?Q?VjKLSZ6sdmv/EztigwCF9dPgEfO6YVj6C79qb2Kyty241vIM0nQWqgfzM0?=
 =?iso-8859-1?Q?3BiaSQE8aFUyekaMPOmDBKac7vq5EOayOTNz0ciwg1Jc6iyoRnSxmVDhfC?=
 =?iso-8859-1?Q?YEUeSDUMWQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4cb399a-09ae-4ae8-7b13-08de586f4cbb
X-MS-Exchange-CrossTenant-AuthSource: CH2PR02MB6760.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 22:00:18.7307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+MFjPGz1hsHZjC+k86XEq4xJP+iqrrhdnEEmjfHscnO4aquRe1t220gy2vJM1TSkw1KUAaEt0DT+bcTp2LJZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8460
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE4MyBTYWx0ZWRfX2X5WiRpp8jxZ
 2AoMJEF+FIQ7svB/c6PhzOktNKPYo0mC55BRBPqrMlYYURXenplSPBenocUVOReeDIo/dA/Vbr+
 ijSaSPEWOSDz04q1JJWK2ZNTwTM1HaLTYA6UKNkPXXDqHApXdxFTTpu4WrcSs44lmtbTRb6ctE/
 3A6za2y/09mVlcY9eKnwJrU/U/9LzPyunmRDz+zSyeAQ3OQ7tiP917q210e6K/puHA5NemKEEgK
 ZNd+V+nCzMMPhcylx2MJcmxNcKJLW4P/Tch4usOHU2GMHnXHlC4bFo+YRLzKa6OyVL39GDPaurq
 3E1xdOXNCgqXPagA7VHYlCT6Y/4TfGmAtvSEmcHhZOnBeafqiU45MbUheIE6Rqqur/K/yabRL4p
 RBXmH+6bp7izoOED5KZy8oeFeNktGl9xWc9gVRmBB+lKXjCmT8eTbKeBMK3G5W06IPUJF/UDQ2U
 8q4Sm/Uj8E5LyC/H+sw==
X-Proofpoint-GUID: Wxn2TfJ9u9H_qv-0ib-zxcesARWHdOaH
X-Authority-Analysis: v=2.4 cv=aaVsXBot c=1 sm=1 tr=0 ts=696ffaf5 cx=c_pps
 a=hTY5Tzxx0J6bc07E+BihHw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=ID6ng7r3AAAA:8 a=aYec2LCzbxTgskQ-TsAA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=AkheI1RvQwOzcTXhi5f4:22
X-Proofpoint-ORIG-GUID: Wxn2TfJ9u9H_qv-0ib-zxcesARWHdOaH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_06,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Spamd-Result: default: False [0.54 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68659-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,qemu.org:url];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_MIXED(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	R_DKIM_REJECT(0.00)[nutanix.com:s=selector1];
	DMARC_POLICY_ALLOW(0.00)[nutanix.com,none];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[john.levon@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DKIM_TRACE(0.00)[nutanix.com:+,nutanix.com:-];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 280A64D352
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 14, 2026 at 02:26:48PM -0500, Stefan Hajnoczi wrote:

> I have some thoughts about the vfio-user project idea:

https://wiki.qemu.org/Internships/ProjectIdeas/VFIOUSER
> 
> > === First-Class vfio-user Device Support ===
> >
> > '''Summary:''' Promote QEMU's experimental vfio-user device support to production-ready status by adding comprehensive testing, documentation, migration support, and seamless CLI integration.
> >
> > Since 2022, QEMU has included `x-vfio-user-server` for running emulated PCI devices in standalone processes using the vfio-user protocol. This enables security isolation, modular device development, and flexible deployment architectures.
> >
> > However, adoption has been limited due to:
> > * '''Experimental status''' - All components use `x-` prefix indicating unstable API
> 
> This is a question of whether the command-line interface is stable.
> John Levon, Thanos Makatos, and Cédric Le Goater are the maintainers
> for vfio-user. I wonder what their thoughts on removing the "x-" are?

Just remembered I hadn't replied here in public. Actually, Jag and Elena are the
maintainers of the server portion of this, so would be interested in their
opinions.

As a maintainer of the client side, I think this is a great project, though, and
would love to see vfio-user-server brought back into a good working state and
the legacy protocol dropped! And we would be happy to support where we can.

> The vfio-user protocol has adopted the kernel VFIO interface's device
> state migration features. In theory the protocol supports migration,
> but I don't see QEMU code that implements the protocol features. If my
> understanding is correct, then there is a (sub-)project here to
> implement live migration protocol features in --device vfio-user-pci
> (the proxy) as well as in --object x-vfio-user-server (QEMU's server)?

Correct; we dropped all the live migration stuff as part of integrating. We have
protocol definitions and library server support for this. There is also somebody
who has some draft qemu patches around!

regards
john

