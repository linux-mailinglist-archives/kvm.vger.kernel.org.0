Return-Path: <kvm+bounces-3380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF31803940
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B22E1F211D9
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0BE2D04A;
	Mon,  4 Dec 2023 15:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nVd9GCsY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2043.outbound.protection.outlook.com [40.107.101.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E62CB0;
	Mon,  4 Dec 2023 07:54:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iANpggWqCQu8AEYvud2IWjVu7j2hBbvD4Fmuoq8yV2dUPqHhX4+zP9lqAAfzSUBqJwbRIWJ6VuLHMH0DR7Ft/okEjFfHK3D4kTmby32MTthnHlDy151GDxNHurH8EeuJLnqcWjim5A9synwPxVXcKKawBQn9vI+WPlEUkBar0q5mQ8ksMQtEXitxwhnXX/+IJoQsYZL4wS0H/nZpCPkWLW1Ta4jrEjLEszGgrYG6Mn/Uk06qtGZbJNKHCquWVM46GQv9fWExsnvDChwRKSXYIxooI1lCq3cb/h4Mh3T0FQ/P6KWDbSKwJ0pMzDsmzT4o34+O1s62jPY76WanPFrVRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/+o9LzxPCagvrWXXJd66RcPmVqod3tJRttm82T6Q2A=;
 b=lH8wHitA67/zVHJ1aAIYkHOOUI51KqfirrhLbyi7cGxb8LkQjrK9ijQw0c1W2KykfDdGKoV8M8FKNtyZsa6wEidElOayXYpZzt+xTn0UxI8EYgLy8B2rvTqIJtOinQfFefilEs9CtWJjwaIfeZG+638HlNknJhrOO8qAyvVdM2i4WUKasj2lo5x4u7YdUVzwWdV8rsUOuy0ukD540gNzGfupbPGLzrBZgyW3a1gvEDheiXvHwSUQZu8wuHDAqQcnozJ+NzkxSDLUXPkjNpxI7fLH2gwsltCFbfvqppgtNfi69gC/27i/RWs/BS+mULnJlsFOywRSOC2VACUHNfydrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/+o9LzxPCagvrWXXJd66RcPmVqod3tJRttm82T6Q2A=;
 b=nVd9GCsYe82L46cMVvCzIZ2sC66DBaLBJBHN6lxvVuW3lHovKe7WniLuCJCIMHmmeJuEY0lb1YoKiouTVtwH/dRrKgCpZ5/oqMRzLF9v8zvblyeYX4b85hPBjgQfS3bVa6wgCn17esubxBNH6Hl8ybXD/kC398jdYBIUpT6ClYeHPyHujbiBQYJ2EEGM94TpIDobuSZIQPs0IVXJbgk0eniCIRE833+XzYfAYkbkKH/LLATsAJ1lr24yurGtbh7i/uFAVr0KT8udQR+ZPl7let8zkFgBO6sBuYJXTEmb1L3AqYTRt/3YIWPLBoAOXa+7OwnCxlAl/nR57vFhokiWmw==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by BY5PR12MB4131.namprd12.prod.outlook.com (2603:10b6:a03:212::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 15:54:52 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::946b:df84:1f08:737a]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::946b:df84:1f08:737a%5]) with mapi id 15.20.7046.034; Mon, 4 Dec 2023
 15:54:52 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Borislav Petkov <bp@alien8.de>, Jason Gunthorpe <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "rafael@kernel.org" <rafael@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "james.morse@arm.com"
	<james.morse@arm.com>, "shiju.jose@huawei.com" <shiju.jose@huawei.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, "Anuj
 Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, Matt Ochs
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] mm: Change ghes code to allow poison of non-struct
 pfn
Thread-Topic: [PATCH v2 3/4] mm: Change ghes code to allow poison of
 non-struct pfn
Thread-Index: AQHaHaUO+eDazbYmyEKdCfPlady3ILCWsceAgAKRkACAABC/AIAABGgD
Date: Mon, 4 Dec 2023 15:54:52 +0000
Message-ID:
 <BY5PR12MB3763A85483534C7FD50529C8B086A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231123003513.24292-1-ankita@nvidia.com>
 <20231123003513.24292-4-ankita@nvidia.com>
 <20231202232319.GAZWu8Z6gsLp1kI5Dw@fat_crate.local>
 <20231204143650.GB1493156@nvidia.com>
 <20231204153646.GCZW3yDgal3gztpDRY@fat_crate.local>
In-Reply-To: <20231204153646.GCZW3yDgal3gztpDRY@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|BY5PR12MB4131:EE_
x-ms-office365-filtering-correlation-id: aae3f16b-fa31-4516-9ce9-08dbf4e15a5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 yivIDu/YzHtS2ySM6bHsHGGz+AboQ1oDRIt86/MHapfYE6q/OW0rOI802Uq3hzc4+cZeTKbQ3W/CBpNZX/MVQsXEXwy7FIOjiD8jD4yK/4sR6QT1vYImw8pwIQn/wrv5U4vT1kI9sh5iVhUFRJ9+KeRajDTJ08reGEU6CfAOEU3SL4kqJBrn06w5hrTQKZ9vFwJqPb/PMHNvPJd9xpZN6E4qDYar9i0PS5RCQJZNS+JmQXqcqee2affzNcdfIEtvEVqUvDTC44K/0EhV7cG2fmSG/FU3a98BSZIbcqRhIaSuvgDQ/0X3IcHEo4Ngi7+iYJOFVwvzIvJYuSnSIzv84l9Z4+y2HBtmpB9VaQxSCmLQelpKOnjnlRWBHv2kRIdwuJTRBDkUBkfcyTW9kKdEuxz0f+yvNvOies7MDayy7E2RGfWTBsA8GllAI1DNgB8Q5mrK/Eav+zhCESlpHwG/lCNX+S3iQpYfNES1CkLymX99+Q9SFZAvglO8nzOooDFBYhAroyBHvV39oIbO8awP7BD+wqCKiZ2xiiMUJlako6XqbqjZGmDrI7O2POWCYFROqVg+2YkgBX4ejdqxfpfouQxUKaXpvy9JrpDy6L2x+i6iN/bQB9R0rDnfvnwPrfnD
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(39860400002)(376002)(346002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(66476007)(66556008)(66446008)(66946007)(6636002)(76116006)(316002)(110136005)(54906003)(64756008)(91956017)(38100700002)(7416002)(2906002)(5660300002)(558084003)(86362001)(33656002)(41300700001)(38070700009)(122000001)(4326008)(8936002)(8676002)(52536014)(9686003)(7696005)(6506007)(83380400001)(26005)(55016003)(71200400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ztPvk0Irv//IqRpUJSjM5feVNIkN5S/YmB7yaATu0l+gvGzRwnvbfECLs1?=
 =?iso-8859-1?Q?MzxZkNylJnjrV8SZ/o0wAE/E1qY8MB/ggg4bMMvsE91Nf8Et9gtyFE352k?=
 =?iso-8859-1?Q?+0MuSHE+kMVDNVsLCBghOrc6dVQ+1ZWhhYp5rm+mKCuzm8lJjCZX01uSIJ?=
 =?iso-8859-1?Q?a4C/K5ped3wGGRTyLPnowhzXaeRhaeqO9zur0zxG0CFBcOGD6OBbea7IRP?=
 =?iso-8859-1?Q?8pwziAA5hz747u33Fx/wJxo57FVFUToEyOp+kfPZO5FnELA0ZX6aw7Xv9K?=
 =?iso-8859-1?Q?CaImRnpG1Tt5EbJ4wMFAKQWjfyJMn3m4Xx0LqRA8l6V9Gfewv+IzBlQX3K?=
 =?iso-8859-1?Q?t5grdfpYyIQJOcku1iH0xqCYQA/lq3Nz7mhzK8wi75NQJxYIYrd1+PWYSX?=
 =?iso-8859-1?Q?+ZuhWwQPPQp0CjVN4d06WkE/ucwIIAcdqUfAu99VRD590crHf2fucl8jSd?=
 =?iso-8859-1?Q?n7X0/12bD/GHknd1YhDupUX627NJoorr2Im/QmqCYpgLSKHwwO4llfU07l?=
 =?iso-8859-1?Q?xOFoxnjJYdzB9zEajPCgvXjHwl4Y1mKhgbAxYFeQilFzacaJVXgl8GgHb1?=
 =?iso-8859-1?Q?f4eqbz6I2A6Z/QPxVISOq2opPu0efH9hD6N+75pL/5w9V7hJ00A1CrPY5Q?=
 =?iso-8859-1?Q?uyQ1TLzXouVn0tOktH85NBhMsg/4yVeE3tdQFMSHwjbM31KT2dtpQ2GXq6?=
 =?iso-8859-1?Q?I1hCjLSm1NqTedfc/alNywL5WqzTc1iOrqX/aPj4BAOIWS8WLlsjM8iSPq?=
 =?iso-8859-1?Q?QaYFFxWDMotxl/zb2wDwdwskIKpoU6UID11vXSjJ7F0ZR0TBmujS6s13EX?=
 =?iso-8859-1?Q?mwlRsR6ZdOSC25L3xRvDNdLqz09Pgz8/znsmu85ROqtq22+AEdlZyfWR/X?=
 =?iso-8859-1?Q?3I6wwW2utUhFwJaBpJLZn9lTIPVMfpT4kK7ZpntyycZLIg2hvBl0J0gBfV?=
 =?iso-8859-1?Q?liTI0NhgDVEEr+pTc7Oa2JwreMeWnYaBpv1dYIz25BJDFTs9LGoAy1WEr0?=
 =?iso-8859-1?Q?rsFLYceRc9qDFOgaoxgpuYW0ziVk5qX+BTNqJYenjAROfy6RAdJkPVflRY?=
 =?iso-8859-1?Q?ZhzzOTXxYVZg169zJGL6oVWnnQAez+wdkxFrebq5yU5PtjBI6VJRHKo1/K?=
 =?iso-8859-1?Q?70Ufwv/cypQrlWXI/0jfOPuUg6/iJuFSho1elYVyxSF8ngK8mcm8LUxJwB?=
 =?iso-8859-1?Q?8jhBdLnQeo0pwiMdxC1mmSJe11TadE8TvDuCsJ7CrL8JD9QtcZsnmgN+qT?=
 =?iso-8859-1?Q?tvT23VXI2W88AnmOS2kg027+2/Sb84U0iHZ5AlvBK5Tl1GJb9bErmt7qdY?=
 =?iso-8859-1?Q?jVE69ALNumBOB6sPQc2RGizgCIxfJggl8yVfrKdBWNpmBAcW50tGX80cjg?=
 =?iso-8859-1?Q?F/Qcr5gYvCJhWFUVi2NoLXcdY4GODWtSdWVS1u4keMGCyoJfweZeXHQ1cv?=
 =?iso-8859-1?Q?oFI9Kck1eFvk+uLpcqKjr9EV/gp6+BNlXSEvrcZ3mz/Moxji/jMRNIvrRj?=
 =?iso-8859-1?Q?2z3YsDVvwe0OLBv/ImLN1zRB/b3lMZ802k3kF/kZFBkMnjG0nuyPzoihnP?=
 =?iso-8859-1?Q?J9ZwWNFtKzaVwZQbB53fS3Qi6+OHeCngedTsyBH2+K9u1R+4CsLwP/GHWh?=
 =?iso-8859-1?Q?aPovZcmWag3Us=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae3f16b-fa31-4516-9ce9-08dbf4e15a5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2023 15:54:52.3318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X5e0BfqWkvq6NfnWc9kFk05BonblBSkaXTtbQk0y9/XR7HO9WOzQelWZbi0UzhqSsojQ33EpP/USSnykg+KXrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4131

>> It wasn't removed. patch 1 moved it to memory_failure() where it makes=
=0A=
>> a lot more sense.=0A=
>=0A=
> Why is this a separate patch then?=0A=
=0A=
This was done to keep ghes code separate from the memory failure code.=0A=
I can merge them if that is preferable.=

