Return-Path: <kvm+bounces-58867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E4B6BA3EC0
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 15:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17EBD1C031F7
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC4E2F999F;
	Fri, 26 Sep 2025 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rc2OTeSw"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012040.outbound.protection.outlook.com [40.107.200.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF642F8BFC;
	Fri, 26 Sep 2025 13:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758893986; cv=fail; b=GAc5sNMuKDwASLWjayjl/zdcPtnxnplT6vNCEvW63iOq0EQb9cCG9zIAdpOqwWaah0p6aUdRuR+ol8NnFph3jfCfUJZyl5WVO+ZO3omg+q4ZfvlunvSB7cV+dG+Y15aNh2sDoBrOUyIE5Avf4v3VeUMRK9AfP9cZSa4s1RhxuiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758893986; c=relaxed/simple;
	bh=J8uWpYaz7D7rkvSQNyCE42iKVkDdUnlqQpAFWi8xzVE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lBOJtrygPz12BClXoF17D3uOSUdESl92VkGEb+QNYcSIKrnllBimY84wzOeMKQnUcMnTbKZhndT1yiH97vd644bT48uGFPvGgaaQGIzL48z4iCpl4FL3Xg/0FFaYbyCIiiD88q3bZkZCHSQIaJt7dR/Ccam7SoDFBzSEB7GqnuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rc2OTeSw; arc=fail smtp.client-ip=40.107.200.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QgW7lM9bBxXaUBvVqa1/WkYcWl0UBPRZlos9nNVUe3ijFifn48p4c5Mok+NPRQmUY91ZdH4fEKcklJK/auPjxb0araF7bqnjx/FNYk7xiaN4GmwVDEzrDMgz1vWtN/tEXDwxTp8ejTFOSU0SCLqOLlSD3ctZnbTJibBkbglA+bH7W332YOr4zHtSKNK6aKJlQBQKgwudSviBxB26qVxaP3Tdc4esB55kPTnZ+z4W2Sj+OoLkqiXOpWQv7ZBwAkRnbhMHzjHDwzVRj0DY+h2JpLtCmvM5o49HnaBr1RZHV5Zp/xedr2L2Zs+aLrdCs3yHhsl+0JYtyC9VT2NWNMeDdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xaYsYjRQJoQQemXbva+S+ON0k1a8EzuWd2ScxnX6hWM=;
 b=TP5vT0MBxmRgpTfIXxQXrk/Meq4aTXix3/toQpiQcf6O8CbjORVYu+XWy/2BdBRLngvaICa5+Ndg+/ODHBu3RsSQhhGMqV6jKMKV5ikVIXhv+XJGItZQEsib1wg/enT68WRGWexPnSWM3TBW/oMrOFKNHlNSjpw5VfHqHI3ubSmK2KKDzjzZMxzGvh9D4BmckuMBxDVOK9RGkrc1baYYF5BnYaAdjm507XBr3fgVmmCd1FgcydlpyKAnIpeYnygAHAjfKARFcc7uNngprgNEMCEENhQ+GYkq0aX9VsD0dYCnszUCysfhRBV0GrRskvIrWWxUbfMiWYWK74u0LJcHXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaYsYjRQJoQQemXbva+S+ON0k1a8EzuWd2ScxnX6hWM=;
 b=rc2OTeSwpQX3Mxba31dbx28V8iuho041n1P+IcJAWPUI6IPg5RDpt6TsPKAMeT3W0YKYA7otu0fEKD9nnS+CCgVv/dfbDsdP6YvbxMgZGOXsVbSNRNnjMoifmNTFc5jg02CRdw6lFAEcD04fjimfJOR2Ln7MqXm5r9NOLC+5NMU=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by SN7PR12MB7131.namprd12.prod.outlook.com (2603:10b6:806:2a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 13:39:38 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%5]) with mapi id 15.20.9160.011; Fri, 26 Sep 2025
 13:39:38 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
Subject: RE: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear
 on exit to userspace
Thread-Topic: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear
 on exit to userspace
Thread-Index: AQHcLcnkEpgFX/ZIl0y6qFiuZVHWGrSkMVpwgABDV4CAAQKnUA==
Date: Fri, 26 Sep 2025 13:39:37 +0000
Message-ID:
 <LV3PR12MB9265B1C6D9D36408539B68B9941EA@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
 <20250924-vmscape-bhb-v1-2-da51f0e1934d@linux.intel.com>
 <LV3PR12MB9265478E85AA940EF6EA4D7D941FA@LV3PR12MB9265.namprd12.prod.outlook.com>
 <20250925220251.qfn3w6rukhqr4lcs@desk>
In-Reply-To: <20250925220251.qfn3w6rukhqr4lcs@desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2025-09-26T13:28:35.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|SN7PR12MB7131:EE_
x-ms-office365-filtering-correlation-id: 5d77fb9c-bef3-4351-ef30-08ddfd022341
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?gVF7c6s0/K/3mtWKbNW5I8qLrzsbuoLmzAHzr1a/EhigNtBZ5PAz92cvxyya?=
 =?us-ascii?Q?K3xMt9+oz+u/uVhjxKw2KpfFyPU2/Q+iMVZA64648DP6c9CyfixkdOH4Z+rQ?=
 =?us-ascii?Q?QGshHWjGxLB8QnLwjeWh3oRBLXB02hu2aVXy/K6dwp1qP2cfB9uuDK5n2/41?=
 =?us-ascii?Q?LKIOUNs+ZZ6V777jxomjRzHJHdR8R7sVExDuUvs6CT4AsqrXtNp3GINGpGUt?=
 =?us-ascii?Q?+yoq98Cl/JcQigKA8+iDK2JjjQFMt6OfH+AGx6nAdW5gYPKj8YxfM7NGOjjc?=
 =?us-ascii?Q?pK+nJWL3XCX44IqnKjKUxDz7EDKfyOdySyyrGbIJtaiMWJj+WRwVkNtZcyXn?=
 =?us-ascii?Q?cay1oYy0AmgoTzyF+cErsK6broAT2Y+dgdNYL3wAwULvqN9e6iBMO6x6jXaJ?=
 =?us-ascii?Q?nPklvYGG1bc2OsKlYkgMP+sQv1tAhumD1xIEr3mveVT3T0fHfSf0pqMPmUrT?=
 =?us-ascii?Q?PKj5BRAblBrIkc9YnseIqm+3/vPSgm2bJwwaOi2EZ8fis10RpGCf081Xkjvw?=
 =?us-ascii?Q?Td0dElZ2FtVAoi72mXyvO3x9VfEvbwI5QKj11CO1CuF69JBnJzJZmQtW0iSC?=
 =?us-ascii?Q?/oVue+jThXyicsUpMCYpESls/0W+oBucn0BUJRzDalXzMmmA4wJj31WxmHA8?=
 =?us-ascii?Q?jdJzTNYxw7VwWZcLJcQh2tMrp2p8SAf/G7JPxs75uIhm3zukJElYue71p9zR?=
 =?us-ascii?Q?hJjoFFbjP/DZe2+uBKRe8vWR6pU+Umhkt+MVob4ph6DDE40hewA4sYG7hvQK?=
 =?us-ascii?Q?b0v0x0cSKGNGtzdznzBWQeC9t5ip88weKEqbwaOH39TBJ65RpIt4/h2JVPnV?=
 =?us-ascii?Q?Uz7Rl3pWDllfhKxUFLpY2u7/aEAehTlZgW9bqD6XhtYMMgw/ajl7P/2/sCAS?=
 =?us-ascii?Q?oxDXJax/990taBLZKTMeH1rvDF3/yIHOCI529ihP6+hSF1+tvyCbLBbuw+RQ?=
 =?us-ascii?Q?o+jtIMjzZNPh0XWvkkdSJs+tK3PBJsMMjuMT8kQyL8TCioJ+zXKL2VEtwVaU?=
 =?us-ascii?Q?V8pdDEN5tMs3/RgXEs+jGXqmUhNpWPCCTk3Uejxq2xlgNURMtuV4nl84jYCE?=
 =?us-ascii?Q?Ud5qZiTWbd1U10fErbLrA0FPlRj4Xg1SV/2J8UmjrUsh7+FzswgkUojHNvSv?=
 =?us-ascii?Q?oHeS+mbi2EvzZkWkUe6bdYEZpv5tkEbiKQsWUFX/htouUruOzh5hRZ0KvHph?=
 =?us-ascii?Q?jPXbSCtsVXBk60A10k9zJDldwg7+eHlnWZ3Nx39wyu4oU6l0CpdZwAbNGBzi?=
 =?us-ascii?Q?7PTleIfIzfEuniWVRZrg+g5Y9Lj6bqXYvzJi5UzHXz7fHM27gzDunK1WJx4y?=
 =?us-ascii?Q?nx0J/tnPIBQLyc+duk+7GTIm8s+EIIkwUd62PIhILXjQmwjyBPYtREX5uLNm?=
 =?us-ascii?Q?eFkE0A1oXWGikHymJ4XRwGADfkTPkFYwsoZjYJoqvKy/4CDDSJkz437aKcuB?=
 =?us-ascii?Q?jvTCTc0cob6Of6ZwIU09rsZqgL1tyhD3mVqlQUtg5yhKGME41c8ZiDL50xTk?=
 =?us-ascii?Q?FW1e2vhvgM0YA0BihlF0Py3v0SysXMlY6FYU?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?L7I/+Ot++47UF3+u8kEnQjPa1wHj3qqlBvyFXafj8qt7VQypKDGOpuEyMSRq?=
 =?us-ascii?Q?GUW6Mgdaks78+xNfsjmmWzhxiUftGltnCnzouHhVSQHpo3KfZ5ID+JVRvYku?=
 =?us-ascii?Q?Q4Uk7R77VcerRDUdjEg8FV7Yh15kJ82K4oo8w6QbAbZtyx0pEUXlgKHLHXf8?=
 =?us-ascii?Q?KclD/7S+KaQYTYtCAuNA9qzIHz2U8XSW8Tkjr49J7TlK7DjR7pTgLrh5a96u?=
 =?us-ascii?Q?NBcl9mK8ADuQ0hsgqXTlRzGskpUGwT9WpEJunhWNrNCGjTCf7CVUZ4CV6W0P?=
 =?us-ascii?Q?0Rt5trVBLcMdZEf2Qd0lTXxqVhgABP+0td6OoIo66UiHhbFp5Dnemvxj2ldu?=
 =?us-ascii?Q?cNEsRhrl2zLzjt9DNudfMXIA/+P9AJ0Z0SQdwidV7122DZuBJQdEqtLzVUSq?=
 =?us-ascii?Q?UrKy8NQffMtFwWiOM6OXYDgRLhp+WZJJHgTMD2+n587WabFMD/kEScCcl0ry?=
 =?us-ascii?Q?q89HlpwjGis053s4uAyC+CRahH6kljtL5OdQPhSUUXJVnLi7Qn++JkSnS34f?=
 =?us-ascii?Q?Oxx1HEh8ckfKigPqksGMk2BnKDYL+j0alXl6lUnxRQVz9NIoOOR5ESLg5AUc?=
 =?us-ascii?Q?cSqsx/cM13oz83D74PWrN0j18by0AGTZyqqfMRvuuvB0vqtzmKEf2nNZDtBM?=
 =?us-ascii?Q?Ua94c5FFxVFwHzRslByJkYHwXrjz6J4n5+3a4f2ln8KefCg1mE1nMabWdRgB?=
 =?us-ascii?Q?x30wLFhudnHzwJxT1rlpq9ieNdJGoCNpbVoxk+KAK1/gbNKr30h1eVxkOUmd?=
 =?us-ascii?Q?fPYRGj9taJVKBDTeurbMwWqLvvxdQAn/B59/IV3GDGZcmmWY8QSp2L5erACT?=
 =?us-ascii?Q?dMrGVhlVMefzdNJ9W3OyZc9f21gZD8/NRx2pha7coKNrxPUT0P6CjMC0Lodr?=
 =?us-ascii?Q?4gjVCVcmTgWrv3qJ6SoEGNS8Hp/WE5bYJGQZF7Fmyzr3XdY4NnW1X9W87nfG?=
 =?us-ascii?Q?hGB1OpNaA5mT5iXiWh1PkWTd+uak0iIg8ipgiKK6iJa+QfRu2hM1jmH5Zu/G?=
 =?us-ascii?Q?GI2OGiXJ5YbtoVIblzhv2oHLfOE4gMxT3A3Fsxa2xP9YXhxuL5m/g4mk1Hnr?=
 =?us-ascii?Q?p7esgexuwtChJhGwCv5GzKwozpd4Jw4+XA4Tp1IWKViMuxFm1/z9BFqTKxmg?=
 =?us-ascii?Q?mJ8zbiZTfidqPHFAIW0hdqyHCrTfGxJBaCtZQ8KrbNomTlipE0sK0hmp2gmy?=
 =?us-ascii?Q?9vlKUbLALWUzneWsMnM8phg9FG0Q9QnNfdKEyzWXIwgrOBIw7oWO0h8pbqk2?=
 =?us-ascii?Q?Tl/9Maeoc16kEyB15Fp9uGsSRxZLW5hl89NqPa9+Xi3uINPIL2nPeeFbl/7S?=
 =?us-ascii?Q?sJ9zzV/K8GUmzabaYExbZK+tYqcLvlb05KnvIUxWC8Pwy9dSNj8JdgKXEDKx?=
 =?us-ascii?Q?YjZdlhxzDawkhV6YOj+TVtB0Sn/hqtgKAiDhtLVUJT0407Y159WfrGMP8CcT?=
 =?us-ascii?Q?CggYuwMkXK+Ao+eJXq/UsijdOIoX/o2P3wXXVZbwxIThWNbAv7VoBw6BW7Jt?=
 =?us-ascii?Q?oy8xXVqoXJgTbEsyp8mEnAjkVRf7ywXmEr3cn1wXA04Ydjmd95hejHYOMWUC?=
 =?us-ascii?Q?cBs509dSMjyONg6Rqo0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d77fb9c-bef3-4351-ef30-08ddfd022341
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 13:39:37.9359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KMgshhCKoDsBtvkyr+Do5A4EpBBzT+TcXI7hkuYiY8CIcYa2HoeNPl17Z5ASVQIt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7131

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Sent: Thursday, September 25, 2025 5:03 PM
> To: Kaplan, David <David.Kaplan@amd.com>
> Cc: x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; Josh Poimboeuf
> <jpoimboe@kernel.org>; Sean Christopherson <seanjc@google.com>; Paolo
> Bonzini <pbonzini@redhat.com>; linux-kernel@vger.kernel.org;
> kvm@vger.kernel.org; Asit Mallick <asit.k.mallick@intel.com>; Tao Zhang
> <tao1.zhang@intel.com>
> Subject: Re: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history cl=
ear on
> exit to userspace
>
> Caution: This message originated from an External Source. Use proper caut=
ion
> when opening attachments, clicking links, or responding.
>
>
> On Thu, Sep 25, 2025 at 06:14:54PM +0000, Kaplan, David wrote:
> > [AMD Official Use Only - AMD Internal Distribution Only]
> >
> > > -----Original Message-----
> > > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > > Sent: Wednesday, September 24, 2025 10:10 PM
> > > To: x86@kernel.org; H. Peter Anvin <hpa@zytor.com>; Josh Poimboeuf
> > > <jpoimboe@kernel.org>; Kaplan, David <David.Kaplan@amd.com>; Sean
> > > Christopherson <seanjc@google.com>; Paolo Bonzini <pbonzini@redhat.co=
m>
> > > Cc: linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Asit Mallick
> > > <asit.k.mallick@intel.com>; Tao Zhang <tao1.zhang@intel.com>
> > > Subject: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history cl=
ear on
> exit
> > > to userspace
> > >
> > > Caution: This message originated from an External Source. Use proper =
caution
> > > when opening attachments, clicking links, or responding.
> > >
> > >
> > > IBPB mitigation for VMSCAPE is an overkill for CPUs that are only aff=
ected
> > > by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> > > indirect branch isolation between guest and host userspace. But, a gu=
est
> > > could still poison the branch history.
> > >
> > > To mitigate that, use the recently added clear_bhb_long_loop() to iso=
late
> > > the branch history between guest and userspace. Add cmdline option
> > > 'vmscape=3Dauto' that automatically selects the appropriate mitigatio=
n based
> > > on the CPU.
> > >
> > > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > > ---
> > >  Documentation/admin-guide/hw-vuln/vmscape.rst   |  8 +++++
> > >  Documentation/admin-guide/kernel-parameters.txt |  4 ++-
> > >  arch/x86/include/asm/cpufeatures.h              |  1 +
> > >  arch/x86/include/asm/entry-common.h             | 12 ++++---
> > >  arch/x86/include/asm/nospec-branch.h            |  2 +-
> > >  arch/x86/kernel/cpu/bugs.c                      | 44 +++++++++++++++=
+++-------
> > >  arch/x86/kvm/x86.c                              |  5 +--
> > >  7 files changed, 55 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst
> > > b/Documentation/admin-guide/hw-vuln/vmscape.rst
> > > index
> > >
> d9b9a2b6c114c05a7325e5f3c9d42129339b870b..13ca98f952f97daeb28194c3873e
> > > 945b85eda6a1 100644
> > > --- a/Documentation/admin-guide/hw-vuln/vmscape.rst
> > > +++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
> > > @@ -86,6 +86,10 @@ The possible values in this file are:
> > >     run a potentially malicious guest and issues an IBPB before the f=
irst
> > >     exit to userspace after VM-exit.
> > >
> > > + * 'Mitigation: Clear BHB before exit to userspace':
> > > +
> > > +   As above conditional BHB clearing mitigation is enabled.
> > > +
> > >   * 'Mitigation: IBPB on VMEXIT':
> > >
> > >     IBPB is issued on every VM-exit. This occurs when other mitigatio=
ns like
> > > @@ -108,3 +112,7 @@ The mitigation can be controlled via the ``vmscap=
e=3D``
> > > command line parameter:
> > >
> > >     Force vulnerability detection and mitigation even on processors t=
hat are
> > >     not known to be affected.
> > > +
> > > + * ``vmscape=3Dauto``:
> > > +
> > > +   Choose the mitigation based on the VMSCAPE variant the CPU is aff=
ected
> by.
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt
> > > b/Documentation/admin-guide/kernel-parameters.txt
> > > index
> > >
> 5a7a83c411e9c526f8df6d28beb4c784aec3cac9..4596bfcb401f1a89d2dc5ed8c44c8
> > > 3628c9c5dfe 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -8048,9 +8048,11 @@
> > >
> > >                         off             - disable the mitigation
> > >                         ibpb            - use Indirect Branch Predict=
ion Barrier
> > > -                                         (IBPB) mitigation (default)
> > > +                                         (IBPB) mitigation
> > >                         force           - force vulnerability detecti=
on even on
> > >                                           unaffected processors
> > > +                       auto            - (default) automatically sel=
ect IBPB
> > > +                                         or BHB clear mitigation bas=
ed on CPU
> >
> > Many of the other bugs (like srso, l1tf, bhi, etc.) do not have explici=
t
> > 'auto' options as 'auto' is implied by the lack of an explicit option.
> > Is there really value in creating an explicit 'auto' option here?
>
> Hmm, so to get the BHB clear mitigation do we advise the users to remove
> the vmscape=3D parameter? That feels a bit weird to me. Also, with
> CONFIG_MITIGATION_VMSCAPE=3Dn a user can get IBPB mitigation with
> vmscape=3Dibpb, but there is not way to get the BHB clear mitigation.
>

Maybe a better solution instead is to add a new option 'vmscape=3Don'.

If we look at the other most recently added bugs like TSA and ITS, neither =
have an explicit 'auto' cmdline option.  But they do have 'on' cmdline opti=
ons.

The difference between 'auto' and 'on' is that 'auto' defers to the attack =
vector controls while 'on' means 'enable this mitigation if the CPU is vuln=
erable' (as opposed to 'force' which will enable it even if not vulnerable)=
.

An explicit 'vmscape=3Don' could give users an option to ensure the mitigat=
ion is used (regardless of attack vectors) and could choose the best mitiga=
tion (BHB clear if available, otherwise IBPB).

I'd still advise users to not specify any option here unless they know what=
 they're doing.  But an 'on' option would arguably be more consistent with =
the other recent bugs and maybe meets the needs you're after?

--David Kaplan

