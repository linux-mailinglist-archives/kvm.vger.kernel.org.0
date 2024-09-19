Return-Path: <kvm+bounces-27119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2EE497C2C0
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFA521C21674
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 02:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2141DA4C;
	Thu, 19 Sep 2024 02:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="uOuU+dW3"
X-Original-To: kvm@vger.kernel.org
Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A413C0B
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 02:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726711396; cv=fail; b=AoY6ffmezMIWXoNYTCHF45iAQHojqqQ/O0NRmQ6abbVz5VFRbnJKDBBeXiNq0DM2G9cjYoy+WxKK15QTmdtUrWJxt1exJi1lV/omToGQN4NhwzLjaga1+pj1oqd1pQkivEnaN8OhuO23Irt6P4u28swZV4tuVLnl0SlfMlDl1Kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726711396; c=relaxed/simple;
	bh=joTtLr6+YIx1dv9cOXDi15iAUWkeRboaWU30VEpkOrU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A9kPtlai5ciN9/92F6UufxbssBEmtnrcoxJ5TKEvoF8TdJAvjscGrM5KCr2OaIiDhs+5ZBOlO74oCp88FKVAf2P70AWeHH3vZEmiw4KZrwtyhQd1TvSr2OA8GTwCsBfwVlIOnACpCqwBzISce+Xu8Qy0ZlhHxc28I+1DUzY4744=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=uOuU+dW3; arc=fail smtp.client-ip=68.232.156.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1726711394; x=1758247394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=joTtLr6+YIx1dv9cOXDi15iAUWkeRboaWU30VEpkOrU=;
  b=uOuU+dW3sArKR8hPDu2i9K2YDwmP17EqRq/XS6zDua8GnzTAcU8qgtDq
   PivrqmfN8YbwsJz0bBuxCwsjnjZH/Ydb/NPPL9WaDnz/rbPIDBIW5k2H1
   dxqoFHORnSJVCehsfgLbDkRQ/P3iXiDChIWGjdCjGGc7is5n+KLq57A7P
   cgxzEq9+4lxIKH6p+Edn5CjofThdqXnwtS8DlIwZf9bl798qqNzYvvWTo
   BntdpPZ2oxQORgobrTexH71kFsLS7fyYa0QpdQrSVboHlOtScpdIKvAmc
   cgw3Xe0ZMRGIxn7iXzEVMGBcqhDMtj5bto7sKtMuf7wprAiox1kH0c3bj
   A==;
X-CSE-ConnectionGUID: 5l6tvzCzQtO08pCzykJThw==
X-CSE-MsgGUID: rdpuDmMrSIaQeQyFEDJb7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11168"; a="130736012"
X-IronPort-AV: E=Sophos;i="6.10,157,1719846000"; 
   d="scan'208";a="130736012"
Received: from mail-japanwestazlp17010002.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.2])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2024 11:01:47 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b/u/qct9hTR3f6zYo71Ne+K2Q1XyYHlrBVhf2fHag2KsOSsiEqO3kqk7JaCbbcOIYzlfMBdJwSnPgu2m3tHhvcu/t8g8agLk5I7uljL0jb7WKXOFarxTUjN4/48zR72xITVuyPgZq5QZqUdDBJlYwuf2fj1BYE4yCheL8fhkfILGLRlx2mh1vsBA3mFRDwdPVuNZCT7xhhh4OK3F24dbPlIAsfGXFiDF6Rcw+TNGMMtB93HzIMJHUwDIEJVmg5ZEhyevCUnziArCVEOd6GTBw2c6l/37jWoVpZRyNHy1lUpZisIx1Eg4+zFJ9Dc5kIwQqVWRQwh7UXeMli+dpzRUlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joTtLr6+YIx1dv9cOXDi15iAUWkeRboaWU30VEpkOrU=;
 b=VGeJzdkZ1GDOAJh1sEo0TWrL+lWnEK7mHI8Q51KlujcCuCbYs/z8UjsahNq/kX+fq6Jun8DQISqNjCDcrmAHAPTbWiCTEbLj0DLwB91TLtQzNX62zIjKgcWP56SgSuzkqgfjfD78NlgUzmTiDB6Ajev5LYR4xgHkb6WXKLIwgufpBJdZ7E+7wobIReGUESLXdJuTrnRUo8T3UB3pM3cfrFH6zz4RlWFgyQt+i9lw3GZHjTTPPp3U1Jj6zvWK5euP0HDTjSrn7c+SFbKiCh5Q+Hg5bDhWsrgDHydvYFHtpy+xG2wS4rm/NZTMRnv2R02Ed9QSqtoM/vtmRim+9NIRvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com (2603:1096:604:ed::14)
 by TYWPR01MB11272.jpnprd01.prod.outlook.com (2603:1096:400:3f6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.16; Thu, 19 Sep
 2024 02:01:43 +0000
Received: from OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11]) by OSZPR01MB6453.jpnprd01.prod.outlook.com
 ([fe80::9ef5:e83:9047:de11%6]) with mapi id 15.20.7962.022; Thu, 19 Sep 2024
 02:01:42 +0000
From: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
CC: Jason Wang <jasowang@redhat.com>, =?utf-8?B?QWxleCBCZW5uw6ll?=
	<alex.bennee@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Marcelo
 Tosatti <mtosatti@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Klaus
 Jensen <its@irrelevant.dk>, WANG Xuerui <git@xen0n.name>, Halil Pasic
	<pasic@linux.ibm.com>, Rob Herring <robh@kernel.org>, Michael Rolnik
	<mrolnik@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, Peter Maydell
	<peter.maydell@linaro.org>, Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>, Corey Minyard <minyard@acm.org>, Keith Busch
	<kbusch@kernel.org>, Thomas Huth <thuth@redhat.com>, "Maciej S. Szmigiero"
	<maciej.szmigiero@oracle.com>, Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Jesper
 Devantier <foss@defmacro.it>, Hyman Huang <yong.huang@smartx.com>,
	=?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Palmer
 Dabbelt <palmer@dabbelt.com>, "qemu-s390x@nongnu.org"
	<qemu-s390x@nongnu.org>, Laurent Vivier <laurent@vivier.eu>,
	"qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>, "Richard W.M. Jones"
	<rjones@redhat.com>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Aurelien
 Jarno <aurelien@aurel32.net>, =?utf-8?B?RGFuaWVsIFAuIEJlcnJhbmfDqQ==?=
	<berrange@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>, Hanna Reitz
	<hreitz@redhat.com>, Ani Sinha <anisinha@redhat.com>, "qemu-ppc@nongnu.org"
	<qemu-ppc@nongnu.org>, =?utf-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?=
	<marcandre.lureau@redhat.com>, Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>, Helge
 Deller <deller@gmx.de>, Peter Xu <peterx@redhat.com>, Daniel Henrique Barboza
	<danielhb413@gmail.com>, Dmitry Fleytman <dmitry.fleytman@gmail.com>, Nina
 Schoetterl-Glausch <nsg@linux.ibm.com>, Yanan Wang <wangyanan55@huawei.com>,
	"qemu-arm@nongnu.org" <qemu-arm@nongnu.org>, Igor Mammedov
	<imammedo@redhat.com>, Jean-Christophe Dubois <jcd@tribudubois.net>, Eric
 Farman <farman@linux.ibm.com>, Sriram Yagnaraman
	<sriram.yagnaraman@ericsson.com>, "qemu-block@nongnu.org"
	<qemu-block@nongnu.org>, Stefan Berger <stefanb@linux.vnet.ibm.com>, Joel
 Stanley <joel@jms.id.au>, Eduardo Habkost <eduardo@habkost.net>, David Gibson
	<david@gibson.dropbear.id.au>, Fam Zheng <fam@euphon.net>, Weiwei Li
	<liwei1518@gmail.com>, Markus Armbruster <armbru@redhat.com>
Subject: RE: [PATCH v2 00/48] Use g_assert_not_reached instead of
 (g_)assert(0, false)
Thread-Topic: [PATCH v2 00/48] Use g_assert_not_reached instead of
 (g_)assert(0, false)
Thread-Index: AQHbBOcD6IgVKZuIjkK8WaTrDJ6NE7JU78/AgAkvXgCAADo4YA==
Date: Thu, 19 Sep 2024 02:01:42 +0000
Message-ID:
 <OSZPR01MB6453F232C6C3877C10A7106A8D632@OSZPR01MB6453.jpnprd01.prod.outlook.com>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
 <OSZPR01MB6453486D937E15FBF6AEAD018D652@OSZPR01MB6453.jpnprd01.prod.outlook.com>
 <fada9192-1f49-4ccc-a3e0-30f17459eb31@linaro.org>
In-Reply-To: <fada9192-1f49-4ccc-a3e0-30f17459eb31@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9NDQ0Y2ZkZTEtNzI3Yy00NWY5LWJkZTAtZGI4NzYwYmYz?=
 =?utf-8?B?NzRkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI0LTA5LTE5VDAxOjE2OjU3WjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB6453:EE_|TYWPR01MB11272:EE_
x-ms-office365-filtering-correlation-id: 456dde57-dcad-4443-f033-08dcd84f0214
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?YUFPd3BIQmZDV08waG1lV0pKNnZiVXkwZFd1QnllR3hiSWE3eUU2aWl5UWs4?=
 =?utf-8?B?U2lFTWxBUks0b1c5MkxaVUxQOENsZnp6WWpob1J1OWMySzU5WFBTdDFZb1U2?=
 =?utf-8?B?akRRa2xORDRIczlweEUzZHhhdVhLNCt1aW5keWZXbC9ENm5PWTFHR1pjbTF5?=
 =?utf-8?B?ZFBySTZ2a1IzWUNMSnlXRWtSUTMvQmYyU3RHMHFaU0tGZ2I0T1lhZmQ5RTlI?=
 =?utf-8?B?djlxTmNDR1NBK2NSWVp1aHI5Vmp0SlhxQ3M2bk9RdE4yai9PZERpT1RpTmJB?=
 =?utf-8?B?VUI5RE1jbTVpTHZJRzBpaGxOOW9vUldIT0h2dFI0S05ybUhmOW5vVW1uUVR5?=
 =?utf-8?B?TGtrVFRhNGk1cG94MnVwTWFRQk9KVHpEOVlXcjUyUGlQVmJ0RVNMVTRlamZz?=
 =?utf-8?B?MzhuSTFHaWdNQndoVjJVUUdsNGZKWFErR1FMdTFmditTUjJoOEFuSVNIelRj?=
 =?utf-8?B?UGQwd2J5aGtVV1FZZGdRazJsZ2U3OWdSb2diY0JXWXM3aEo3YUtQLyttWENq?=
 =?utf-8?B?L2JRVFNlMm5FYjhhamdnb3JRc3NHZm1pdFBGb0IxTzB3Q2s1eFFMYlZNUjZi?=
 =?utf-8?B?VU1saGRRWk5TUThrdzZ0bGg1V2duNW1OdVZXbDJXOWFKRy9ZZTQxbGJkL1lU?=
 =?utf-8?B?a3RlcDYvK2xORE1ibDFCUFZMR2crQ1JJakNsa0hINnI4Wjc0UmpOKzUvWTMy?=
 =?utf-8?B?TnRwY2I2Y25RZEtEeEpUZTBLWTk4Ylo5d2V6MURCR1Y3M2R0aVRDek1rTVgz?=
 =?utf-8?B?NVZNWkVVcnk3TW9VV0hZcTZGbGVxd2JZdkg1bzhZSTNNWlROMUxWQU5vY0o4?=
 =?utf-8?B?KysxOUFuUTJBL1FuNkFtR0V0NUpBbnZxekpYQXNTVUM4RE9sR1M4c3BKK3dX?=
 =?utf-8?B?SHM0S2V6ZDE3VHpGSnV0eVhoczdRejZRNWpvdkdpT0ZZQjNkcFI2aGN0Y1p3?=
 =?utf-8?B?WmxIcUNNK0hLM3NJQzZIaWhjVmZJT09JMVRzL002ZGRvaldvN3lLbkl2Z0pH?=
 =?utf-8?B?VE1OUG8vcFZ2cWdSY1ZialFYaitGOGNUbEhyd2FGanF1OE51a0xCSUw3T1Jo?=
 =?utf-8?B?SzhJZGxCcmJnK1JpOXNFV3FsUmJxbXBIak9tNTFLS01LSW5XQ1dobGtWT1JG?=
 =?utf-8?B?cDB6WXR6QWtFYWh4NzVvNERtbjFTQkZrT0daYVNDQUZmY3lhNEt1bUozL1p1?=
 =?utf-8?B?TFRtam9OemZoMHVXNEM0ZkE0Zy9rWnJqK09xM3hDOXBRWlBUM1B6aUhyR2FV?=
 =?utf-8?B?eVl1MFp4ZkEvSkpad1ZiU0Z3YU1idU1GK1FUNnZoQmp2Vk90bElicDFvZzl4?=
 =?utf-8?B?dUxNNlZxbFZsODdub1Jld3U1cmFXUzVReDE0bUorRWhRRWN3Qldzb2pGSldR?=
 =?utf-8?B?ZEkyZktHd2M2RDNrUkk5R1FYdmdMc2V0VDhpd0QrVnVpQlo3N0tnOXlRN21D?=
 =?utf-8?B?SW1qeXU3YVl6MmdTWXpYRU9SNUlvMnR3dEsxZXJ2dEx0U083K25GQm9xdUlw?=
 =?utf-8?B?NEJ6ZVJjK1cxZXBqWmtoY1RGMDQyUmJqKzRHTXhQbnI0WXZRRHY2UTAwNnBH?=
 =?utf-8?B?MWsrVHg5cDVYMGRCWDZCNytqRmlqb1pGbk12aHdqK1dXbm93cHJONytncmZH?=
 =?utf-8?B?eFYrMitUWHNOUVNtYVNIVVVTWld6ZmI5THpTelNreTc2QzgvUTRYWC95QWxo?=
 =?utf-8?B?WDJOT042Sld5ZmhZOG1hT1RrRnI5czVIUjFIbllST0ZXTHVUaGlRVndBbkp4?=
 =?utf-8?B?UnhEaUxGQTNDS2J5b295U0tDUHhRN0oxR3c1eXBPNHp2dGRKTzNCR1JRT0ZS?=
 =?utf-8?B?aTRSbU1IdDVDQlVDbEhZSUVWc1dTaStkTHFCNGhTT3dSUURVd1RkbjJVOFFv?=
 =?utf-8?B?bDQyM25QRmhjQVRRdzBMeHBjaEJYSnhrblI1Qk9Qc0djcExHdW9wWkVySTFj?=
 =?utf-8?Q?p42L10k+TEo=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB6453.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aitzU2RRMmlwUGIvSlNRVEtJNXlpNFMxcEl1ZGN2OFA2VXdDMi9XeXBENGRS?=
 =?utf-8?B?MzdDZytnK3U1Yk9XNVdpQmVaaTNWME1WQWVvV1ExWkJOVitTdWd1ZklKUGwx?=
 =?utf-8?B?Zk5QOXduNTQ4Ky9QTVpsR2VYMTh3UHZsSzM2NU5EZCtQLzN3V0lNQ3h3MWNG?=
 =?utf-8?B?ZEtkbUFyK1JmVC9HNmNEeGZzZjNXMXpPZW12N2x3dnVkelRXSUphNzczQkE4?=
 =?utf-8?B?SWxEd1puVUNWbjVqbjd0YzYwLyttWkl6dlc5c0RnV2VwR2RLc2QyRkFlNWtR?=
 =?utf-8?B?N1RxUVNXVWpQTVFHSUJHam5tZng1T0VXbEhkc3poQWNwYlJsS1RiYjFsSXhU?=
 =?utf-8?B?S05uSTVyQjVpNWJsTnpLL1MwL3RsdEdyd0ZjMkJrQUJ4cVExYjFWNUxUeFJ6?=
 =?utf-8?B?cmpBaGVFcjRvRklFd0NTL09UdGt2SVdsSjZGc1NaTWpVMk10MGlWa0hzaUR1?=
 =?utf-8?B?MSt5RHdwTXJqZXBUM1cxbm91dXpqUG53dzZGZnpTYzNYdERqQ1krZGxuV1pM?=
 =?utf-8?B?MGZNZGRQUGg4Z2UxU1VjREpkY0xYNkkxbUhYVWRJb0tNWHZ5WFR1cWpLRktY?=
 =?utf-8?B?Q0I1SGJJRHN1R2FxUm5EMzB6TnlGZnRFSlkwcVRMY0xFWHNrMm1ISU81WVE3?=
 =?utf-8?B?RlBySlBvTlM4ODAxUExIa2oyVjFUTmpKWVEwL3JUUmEvVE5WNmh3SVNpY2RH?=
 =?utf-8?B?OG56VEU0RmoxTW1aTlhZMEJVeU5XMzd4VGk0Wmdyak4xaVN5eU1WNXBWZnJ0?=
 =?utf-8?B?cWVjMEdWSmNFUDQ5VzhwN0lyZGp6YmxiMEdpY1J0TnVHdlhPSUc2QnZZVXlW?=
 =?utf-8?B?Qm84dEE3L2E4QUZrU05PVkNDcWFQSDRrMnBtaWlBNW9xVjBzSVZ6K2s0NUxr?=
 =?utf-8?B?MHJMR3RyN0ZCd0t3ZVUzanBQM3VEa0hnVXZTeGZQZ3FqZkxjRnBadElDdmJ2?=
 =?utf-8?B?TnVrSU5jTzF6SURsZ0ZaZ1VTVWtvV2JUc1dzWC9VZnNRd21UVERHYjVGUWtM?=
 =?utf-8?B?bnVXZGdLakxBYjg3N3ljZWt1R3pyQ2prblRXSFc3WnkvTFdPWlhidWdPUC9t?=
 =?utf-8?B?ZXRITU9YVTJFTmNMT2dZaFB0enFJT0I0RHdxUk9zeWZTZU5WdmFBTU14OUFC?=
 =?utf-8?B?M3RINUY4aVgxdkUrdDVpTnpDOXdYT0dvOU5MeEhJR1JmZldXY0lZL3VTZGlN?=
 =?utf-8?B?MnBWOWNib2tCK2dieGJ2VHBGRTV2NzhIN0RHVjh2ZjcycGtqemJFQnF0VjVR?=
 =?utf-8?B?U0xpdldNT3o1N2tHM21IYXJ3WWFXYkZyWEZYaThrWWJ0eTBNNEtZWnpHdStU?=
 =?utf-8?B?alhtR0VqZ1JDZitIaHRDbmdPeVNzeEkycW9xT1RVTTB0NHFlLzlmdmZCRFlT?=
 =?utf-8?B?Z1JuMFp5UWt2WmxFZG9kNUwzQjZNLzVZU1pCZkJ4aWVORWl4SzA3UDF1aW8v?=
 =?utf-8?B?ckNxcklIVGhidkJNa1JBZ3R3WU1XSEFHOGZQQ3JHR2JidkVGYzUxb0lMTVJZ?=
 =?utf-8?B?WnFJQXQ4NHlzOVZqczJKc3R2YnpYNnVxb3FzVGZSdzJTcVUxUDBjeS9Wd0Zs?=
 =?utf-8?B?d05zWmpOOE9YWkhyMktCWnVDQityenRXVmhKZURoWlp5UzRydmR4VXhnUHdI?=
 =?utf-8?B?aEo0R3VVWVloN2hjN1N0ZXA4RkdLY2R3UlNIMTgwbUJTMWtBVGhWNVJsdW9s?=
 =?utf-8?B?Q0hFOFBRVWk5SVlza2RTaHVLSkg5NmxKM01qU0xyZkk2UjZ2RXU4UzN0UThH?=
 =?utf-8?B?MTAxL1M3V2RMUXRjdk1uTWcxbGV2WFlOaWJMWk5BNlNFL29rWFRKdHVPM3ZG?=
 =?utf-8?B?U0ptalBCUXowZldlQnliTnRVSkhTSHBJd3JYQ0ZiMjhkWURrL05aVmNhZFZx?=
 =?utf-8?B?NHNieG5vNWhWaTFMRkcweE9tTThnbUdQWFFKRUcvS0JJbTUvNmplM29YSmpG?=
 =?utf-8?B?RG1HRU1SL0w2WkdZbjI4Q1ZrMnFKcnlsUklBbXRVU1JEUEFQb2ltU1JrcHFu?=
 =?utf-8?B?dEtraTdQOFJUNC9vSDBsQU9HMVBybndPRXBaTTFwQ3hwbFNQSkdDN1NYRDZI?=
 =?utf-8?B?dzZOYTl4cFlaVGRqRlQ0b0NuMGFNMVZ2ZEJ3VXZCSU44bHEzU0VSQ0VaWXRB?=
 =?utf-8?Q?zBpZlXbxEL2uN2FaD44zMLe0v?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z101d5cjhOt+9mIHANPL/Jz8ZeVQ1Hx9gdojui319jGlcVEjm4V93Y8nJtxc4LM8fJTfEzu0RBSDoEs96gDoFdXZqAnFAFlEojyZLHVGvZNt0O3dkjBxqTS1FzlHnGZEWPGsDZPmecqykybSqg2aM0ZdAzkma75dUp1tHBX851yT4TiQHGs1RO6kY0bKy87updk2sgOeTvi6yuBBenEUSHoTMxYNt5trPukC8McdThxCcnGAGVluzokQtgSUBrhwHeeoIgXqSiYSibzB4IeFAVsFu05OpIGQpP1NJEbDGjXpvq3row8+ZNP+QDgnXvOyMheBZjJ/v6O/vG/toqULBys/FefT56b7cyZwvPg+7iBD3onS1VRqnZn2oJflUKn2jPnk9BPBWvAcJbBhyRe/l8SMRl4DjITi2mc696TMJp/c2HXAqF/atKUa1/i4umFF3vfwf9ZFPlCX/EsZm1AhV3Qj5jireF5sz1Pc5GxOOkWIZHfuCrn/B+6bpHcxTwc8OOMq5DkkodOww+WSGpuktQ6bEqHtvF+RuWu+L1ApiD2QOKRwpyXYfjMbjzT8fgW+ThJKCpbfLDp9aptMYzAQJLD8noKxMM85KmDdIPN57WepBJ/5PEe/Qt67Daw6HYvO
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB6453.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 456dde57-dcad-4443-f033-08dcd84f0214
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2024 02:01:42.8153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KDfyRkuNoUPf0aOQw60ZT5m8VUOJQje98nxTuqBjHATb29iPrAyMcsUR9lRgxAWgcuJT4aZ4YxuNcW0efKagnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB11272

PiA+PiAtLQ0KPiA+PiAyLjM5LjINCj4gPj4NCj4gPg0KPiANCj4gV2hpY2ggb25lIGRpZCB5b3Ug
ZmluZD8gVXNpbmcgd2hpY2ggZ3JlcCBjb21tYW5kPw0KU29ycnksIEkgbWFkZSBhIG1pc3Rha2Uu
IEkgaGF2ZW4ndCBmb3VuZCBhbnl0aGluZyBuZXcgeWV0Lg0K

