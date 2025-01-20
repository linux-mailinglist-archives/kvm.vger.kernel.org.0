Return-Path: <kvm+bounces-36054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB71CA17110
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 18:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0605163AC6
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17901EE008;
	Mon, 20 Jan 2025 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WC2f80do"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EAE1EC017;
	Mon, 20 Jan 2025 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737393189; cv=fail; b=takJ7kHNNBr6+Gv1B5pSOo14aKoBHeSZkQphiV5x1VvGuDuiHwYemXEIyfUoZy8p/Ar3wQbZwXFP/DpqQiy+1TUHg6GCt99Rjf16M+G4dbvxmabsm65htewZFuwuntNGz9cRBsaGpe3rllxRM4HukJze4ByLyldfmNiLdbR22Ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737393189; c=relaxed/simple;
	bh=OaWOdk6nJlvo2CpufhDAJmNlu3khT7NhWggqyLq2Rvo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rvbGKqMyylsDa+i3rjcbd9Rnr6p6kTcN7rb4Qz1rgkF3eaHhxnx7rUzsdT4YXdHQ5Bcu4N6CEOC5+KC1K4V6k41YFcRkdPBoqvDgazuoawimBATNBSMffMGuxHK440GtFQo9Y2Ovy8f9yMHkOSpThVlbDy6Q5zfiXTToKY3kdoE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WC2f80do; arc=fail smtp.client-ip=40.107.94.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d4bm1BHep1I2dCyCoz5QtWVM1tFtTtVoJBqAa9QoTQ7DYGpV8+bB8zujBwBWIWxElzUKK4TFc3NEl2+B9yfXpufBItK/8OYnZLoCLR0WzLO28qHoT+ehNX8D5GDKOrMkkG4jcO341gIyfuEV4FTCrNb3LUssPmsUWfFOv2eT+AAB4hA188W3qLUPCLvxWh48eiN3NMJnNBR4gRXsuo2a/e7npkrjTYbJIlOTEH2PTv81nRlfGv7qCBICs38ov12NZxI0F0awArnjz/cQE0PP5NWGN5Rt+cFMD9wa94b3TzK2cILghCXozPfc92HeXQiwtStybLTUL+TysrXEdiByeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaWOdk6nJlvo2CpufhDAJmNlu3khT7NhWggqyLq2Rvo=;
 b=GXUUjenafHBgWHbM9PoBDLGRT1f1dq9JRtI05oQhJPIojCsWwb6ORaT2jPzPWPggjb+8LoHUjEl40I7zfB1f6iOEv0JrsoO3G5gcBAYuR9W2QEAoWaJBZrym8xPE65jz1OoW4X23GKIcRyOupIfH4V2ynu+625GL6h1rVVq0ndEjcQYwazk6W/pMsONzNdRF+5TRO26/SYqph8GGgRVBrM7OEVAbovez2NLhIzBCq4b8fvVuA4smdWOYNH8EgHNNlrvrDFl740f3uSU38EKYgQ3Y97N2la9okYHGkkcOE4OelbZe+7WxJHf8SRQdtvQHnUhCBvy+w2O8o4eo3GGBEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaWOdk6nJlvo2CpufhDAJmNlu3khT7NhWggqyLq2Rvo=;
 b=WC2f80do+Bkkx8bPrYb0xzT1qiIx7SvSuZVFH8E5LDcY7VgJf5LdBsmCHq7zvxQ1Bl3iErG33pYafd8aaHOdZ+PNYGwXwu+/b6+9vI1C3E9BBRWeFeNx7udRqmQu9KxUXcFvdZdsm4Ge1PA5EroG1Wahp4Tb18vWE2nD3Mlf9YzwBuz2kevr1/1SG8r4hU/T9jMLO2K19qAMJ3OsBvPp8pjBcK26DviHZhdhC0Bq0JuR+owESxJb3ujAybMVhlbxT/3gce7HFRyyDBm7GUj1ss/xaWcqzDAmfaEHCFH9U1Xy33yPHh24yesLLWC9ztAczV67/C9ii9MQ6eM7PxEcsA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB8813.namprd12.prod.outlook.com (2603:10b6:8:14e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 17:13:04 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.020; Mon, 20 Jan 2025
 17:13:04 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, Zhi Wang <zhiw@nvidia.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Thread-Topic: [PATCH v4 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Thread-Index: AQHbaTjDWcHwtKQrw0GVIupvGebUHbMfR7aAgACfyg8=
Date: Mon, 20 Jan 2025 17:13:04 +0000
Message-ID:
 <SA1PR12MB7199B674BAB692662C4E5878B0E72@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
 <20250117233704.3374-3-ankita@nvidia.com>
 <BN9PR11MB5276398787A61A1EE8AF92E48CE72@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To:
 <BN9PR11MB5276398787A61A1EE8AF92E48CE72@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB8813:EE_
x-ms-office365-filtering-correlation-id: 1fd5c470-50ae-4715-f31d-08dd3975b39e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?huTohaqkDMawyNqccK5325pgipypTu92QV98pfUbA9peblJl6Gu7c2njDm?=
 =?iso-8859-1?Q?R5qtYyhMiGePZkC/sDRNvfjjgPkC2NvE3HWkdAPKu2agDVLA1IED521jYv?=
 =?iso-8859-1?Q?G3go0IT2i5Plmt1tXydUr7skTiTnmx83BFr916pfkVaBhtez1rmSf0i34J?=
 =?iso-8859-1?Q?AUBsKcLl2gKIRGpARpSaT9Nb9LAca3p9z5XjTy4MZJJ7ShniD03ALGpBh2?=
 =?iso-8859-1?Q?dE0KRPjYLngsWJUc0iPyXpvaq91c9vPtGb5vP23rLDRLKjwhXLEEeHbSfl?=
 =?iso-8859-1?Q?4MpRKHuzZ9tFhPPAoJHzwunf/xs4H1/i4EOMyHxEohXZDwbqeZdeQ+zn3h?=
 =?iso-8859-1?Q?K1B9AnFwkUTUoW/V6BUCStOhHg7fmYdtcV8SMIM/96RCKmfg0D7BRViLrF?=
 =?iso-8859-1?Q?gMMSQHScPxA03dVF4bQvmL4JRXuzbqeqhBmVJcuVf9UeaEtBOgqp/icwR4?=
 =?iso-8859-1?Q?QFsIACC+C2F7HsMPBpLH7HqDwV9mlavZaciXav54Ek/1UfUKPvY+qjy/Ck?=
 =?iso-8859-1?Q?opxcaZ+4T6SGbSSZKdi1xJ+426/yH5BEyfWA/vwoZ7hY5snhHDyvih/L7C?=
 =?iso-8859-1?Q?gsmdyvapDq39sI/nzKgcxB//4DbluUTSXy5NdhRmZjbmQ0wf4lLezS8JMY?=
 =?iso-8859-1?Q?neorTS/4bW1oPlTBMxs0eFNwKy10J7+rns89qkMXEV26+lDC4yD3XmyWD6?=
 =?iso-8859-1?Q?cfrw808VIPQ09BAS3bJWkDrJ7asNd/VDOwGCl5eVMjX/mvQsLQhimpthym?=
 =?iso-8859-1?Q?l7HjKskHgCY+g0DTUL+mc5Mxrs7mIjO2Qypa6HPCab0d8oLjNB/prEAKKG?=
 =?iso-8859-1?Q?fGKzGnTPVm/dlYAbyqxL3DxSpJfOFgPF8JRkdy+YIYJMKDJbetjvqCngls?=
 =?iso-8859-1?Q?aDHoXRTEJMI1Tp6io69H240fjaUnhGpIqa03/rRgqDfHtv0EW/zMq0CyN0?=
 =?iso-8859-1?Q?gGwWpYNIdiXGIeyEtsBzNTjOH7V9fx2dWlqijqAMtToS3R3aG5hXgMZAGz?=
 =?iso-8859-1?Q?iJ17YzQIr0k2vs2dsZhxU9vtlzI+Sd8nq94SizrvTwNApQI8Gj1kzintEY?=
 =?iso-8859-1?Q?eVWb4ZdLaTJfAlAfzVO+hqt+kKaNBCYf/yi1fU/HtPfbTam7IftE5Qv0iq?=
 =?iso-8859-1?Q?vN+nsmbY6ut9fWyKgn7PTcgs+ljn3LvFHLmEH1YysvbjfP2wnDEe5v2hAg?=
 =?iso-8859-1?Q?PTIT0Vff2uxZiC8UnbBbiBwq0NV/Dmc3AOR7dPqZ9/JdeZDkx4nNlM3Ytx?=
 =?iso-8859-1?Q?kA/RjLmulItfnpjqg2F3n2bO8MGIZfoPkB1kNVDCP8BrZBHKowMFfxQx1J?=
 =?iso-8859-1?Q?Uvpd89wUXr0YLMWMfKn8h6eodISzov7x/WiBo+glPxY6X4n9ZNpdRfGRg6?=
 =?iso-8859-1?Q?4Eds9HdT0VXCMSY+zbw8BXSQJZbdoE6nj4MtqO4KHeQqqywYaSNB6RIpdb?=
 =?iso-8859-1?Q?VbS4L3ydLCf1mnv/sHks1Ogkw6gFegmPOqG/USIxYlfKrWBwnkpk0Ra5z/?=
 =?iso-8859-1?Q?3NV+dUDVXnJexhAD71RFJl?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?C7ePjPayJ1M9qar5dBQkCyBSilmtfZyLnr3IlC2EHaEx8NbQ027KVyHdbr?=
 =?iso-8859-1?Q?abs0zBSeCy/cBP2LGwXWB8l394A2e3Sy0AoPNR2Ofw2NprHV3oHadoh/vk?=
 =?iso-8859-1?Q?Q1wsnoEn/eI3Q0qu6ZR4aEBcZktQFzlNcEY+pUpohFkqyjAjeOlQX0Qft2?=
 =?iso-8859-1?Q?hy0Vmn3iD99p4b5WQLjVKQeBYgvgdINwVsSMBpZsmG7PtD948C7kaC7zW0?=
 =?iso-8859-1?Q?SMd7xWI0Pscvd0+naej7qC6++K4kKllNhsFa0hgUEaSNKHvUlNsP9XhcEe?=
 =?iso-8859-1?Q?RhTh5YTAputoL0GEH6B+mFZ08d4BG4BBIEONzj24JHohRToHm2Flr6ecJS?=
 =?iso-8859-1?Q?3rsqixdiagyR+ANIHlQuuU5QSJoszhtmb3CXCgAM1l5DDRGsOtVPk2m+hZ?=
 =?iso-8859-1?Q?wyTBAucY3PjvaJqn3QF4eG+UhpVTF2rpM3eByfIEL1vw9/RTKGo8VD+vLk?=
 =?iso-8859-1?Q?PsUkC1pJM8ywnEp6R+9Uxq47R2C7BnQpbAKHSgn6vhuGTbnBWiliRD93DG?=
 =?iso-8859-1?Q?4KCuZX0nxAKQLl6S63utpWJghf17+uoxcKouxhgf93D2e2MHlAnK27Jy5Y?=
 =?iso-8859-1?Q?Xl5TaLHs32gbHJc9fnI+UyQARb6/Ag1KKihGq0p4SKK8WpF8sotIlkrKK4?=
 =?iso-8859-1?Q?fC40A/gGRNZDSb7U7dC0goYJBZaYO1Nd336dgD5WyJf+ngAN7sDb7z3NWQ?=
 =?iso-8859-1?Q?No4rLBBpWZLdpNv+tNsOWIm75RRIw6JVTm2M1i3i2/aAwxFeXYaYvVlYK6?=
 =?iso-8859-1?Q?D6j1zWcdknnSKlZGnDkGxhZrWpBm5NDENMHmbkbgjmwMvFxpM9wfv4yGAl?=
 =?iso-8859-1?Q?H8XMpY5ZVaK+49qRGiSaCFZidJKErbREYiErUAwQDpxaUC2446/5DGZ7FO?=
 =?iso-8859-1?Q?WCuTy6kBycqdMMuLnfdE73OaSZrLCkErBDTbBV2i5L9zXC/p0CYS7Lx2cd?=
 =?iso-8859-1?Q?uthUf4oAAxWqmaXJGBQLryJ9bVapOUb4yb+4lr96vxdkgzB1cyA17LWCch?=
 =?iso-8859-1?Q?6PpL6HIiafjd1HzHlEjCedzZnBmRNXj1uU9i4QryGlXgh0BhGgHRvW619D?=
 =?iso-8859-1?Q?8E+4wqV8+2nnvIEB4Jd6HtrARyzwFKWBj65by4qIFqkMtIv07/8lLeHAp+?=
 =?iso-8859-1?Q?vifm5ljwqtMZCh8+9CfqNjMbsclIIp6Y1m9Tc13SZ5aH4ReKoefvm+IlwB?=
 =?iso-8859-1?Q?Vl9J/mgh7UE+FEdzYTll7n/Kk1/2rfEfg+hCfLGUm2XvF3uWPqrzWk486m?=
 =?iso-8859-1?Q?P4ZfYgBR+tiG8TA1l0cCKb0SsehD8J3hdIJCyz+GONY4Xkfevb1baQASgW?=
 =?iso-8859-1?Q?jDIOA4sIUr8Rx2eF9ceac+HPRraRMFFF4gup00T1RwmG+dWXvtiyJL3+uM?=
 =?iso-8859-1?Q?kh+1p7/avgLPoO+Pjd/dHe1OAU/GpExjzT3ZCZ3rjH+yidwEKYKT7XrAlN?=
 =?iso-8859-1?Q?iz0U4gdKpY0v0oIPpb+fevDIz9gJqL0oYW1pDDWIfw9nb4ROFwVMGSbVIk?=
 =?iso-8859-1?Q?rwwx3CdRMMnzYcCw8xnPIErh5E4nwubmDz4DDSscTLpklXIUnAlveU+ZqC?=
 =?iso-8859-1?Q?+xCg4bT0O1wA+00NX5+veIWJnOg0fyRFLO9voDUXjSBFX4JabviGD5u7xH?=
 =?iso-8859-1?Q?3a9FpFwVfIOpI=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd5c470-50ae-4715-f31d-08dd3975b39e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2025 17:13:04.3430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YD05+J9rXS2UJLhGnc2WENbdWWZbsk2cpNmzWABp/75/UC8jQ3WlKfJWt8W/5KjOhH17QTkVqRltIz/dDNN2XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8813

>> +=A0=A0=A0=A0 if (!nvdev->has_mig_hw_bug_fix) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * If the device memory is split=
 to workaround the MIG bug,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * the USEMEM part of the device=
 memory has to be=0A=
>> MEMBLK_SIZE=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * aligned. This is a hardwired =
ABI value between the GPU FW=0A=
>> and=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * VFIO driver. The VM device dr=
iver is also aware of it and=0A=
>> make=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * use of the value for its calc=
ulation to determine USEMEM=0A=
>> size.=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Note that the device memory m=
ay not be 512M aligned.=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * If the hardware has the fix f=
or MIG, there is no=0A=
>> requirement=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * for splitting the device memo=
ry to create RESMEM. The=0A=
>> entire=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * device memory is usable and w=
ill be USEMEM.=0A=
>=0A=
> Just double confirm. With the fix it's not required to have the usemem=0A=
> 512M aligned, or does hardware guarantee that usemem is always=0A=
> 512M aligned?=0A=
=0A=
The first one - On devices without the MIG bug, the device memory=0A=
passed to the VM need not be 512M aligned. The devices may still have=0A=
non 512M aligned memory.=0A=
=0A=
> And it's clearer to return early when the fix is there so the majority of=
=0A=
> the existing code can be left intact instead of causing unnecessary=0A=
> indent here.=0A=
=0A=
I think that can be done. We calculate nvdev->usemem.bar_size down=0A=
the function, but I suppose that can be moved up before returning=0A=
early.=

