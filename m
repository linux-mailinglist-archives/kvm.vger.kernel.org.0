Return-Path: <kvm+bounces-3630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFBD1805F1A
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 21:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C7BA281CE9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777826DCF2;
	Tue,  5 Dec 2023 20:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jdv2Wd5o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2D11A4;
	Tue,  5 Dec 2023 12:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701806814; x=1733342814;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2yxEZa4DBCf93II3k1pKkeoz4uIA2S0IS5QgfVkBQSk=;
  b=Jdv2Wd5oN4CpdGTaNKrbEYL2AIh+fD47U1wALjs1ISqEKfpRNhNy0uC4
   La4Fm9V+gRlUwYaTnPpHWpkUwrT7p56GU2hhJNsy9GYQDSgzehh5kg+Xr
   SPP4nb8AkwF/+qNuU9GfgjlTmJhrIFPrifMWPDGsiGobamWE1Lg2sV9ht
   16lNYpAi+mNokifKuNbgt2AYaaY76Q125HvXNBhwQFjm5NLAJ4N9JUsIV
   RwkooEU078yaV9bJWTTAo0lxPh6AA0gl3eWHh7e71GDUZkxKryedjTVnl
   hecJi+V0juDqfrV4Z5LdTnWMkZ9nKt0CwKQC1Eejw0p3G3v/6Q6/EsqTu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="15501978"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="15501978"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 12:06:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="889059454"
X-IronPort-AV: E=Sophos;i="6.04,253,1695711600"; 
   d="scan'208";a="889059454"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 12:06:50 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 12:06:50 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 12:06:46 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 12:06:46 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 12:06:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rn6mOdgbTVkiilntMhjoujlSgiaZUXBb6Y5I+fo3LaOG0uelyOExYTJn6BSWK8brN8GIBaf5O2sZMFVgigbUUpGD4sIgQMBoTXtFpq95ERK9Scjh0nWT8zrr4A6tPFO6RT40YbVJcpYJW9NYsfIHd7X2rtjcvbEQSXgKzyd6u7c75iE3mxmhWL3RndzdqTe+wjB2A0wJL+gC2Voz4h2qDHDpwhbY1VEogKEMwtUfIcd5aSViQzJDBML2H+cwZrqK0LCyOupQUsm1uZpKSqHAUo+7/TxCiFqq6uBkozUe10IYdmnB35x9bF/pptgpcnxREiU+ANYTWbOj0Fcvv92Urg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIs+1DbSuB+l0FIbWtOWxxpV3Bjnvv0DUIP3OoUvrJc=;
 b=IrcWnOvfzpWXMzW45OloKU5K9qPPZ0pw1Yojpwv3ThRAeT9QeHYZeeOfCGrJECbNmlRHYi2PtbA2c7L0ivxgk+3sDRj8AuH+972orKve1DWde59K2YNU1FXNrYADwtJEwbbPMpIifZBvVSzL9co96V3hZxHlIMDI0pneUZk+qn1Ci5yqbDFqAVFws6wNxxjH9RvfthU1wNiio9Tj615p9ETnBczo1gGFmJ7CV1BA8lB1mCEDAgFfdFoIFm/BGJPgbk8BlMBko2rV13Skgb7T/MPY8CyUkCQ96bVymyAkkEsMQjKLAJviNK4z1R2xIizQilOqBD4q549Ardj6lbvgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ0PR11MB5167.namprd11.prod.outlook.com (2603:10b6:a03:2d9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 20:06:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 20:06:39 +0000
Date: Tue, 5 Dec 2023 12:06:12 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>, Dan Williams
	<dan.j.williams@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Michael Roth
	<michael.roth@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, <dan.middleton@intel.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for
 SNP_GUEST_REQUEST NAE event
Message-ID: <656f82b4b1972_45e012944e@dwillia2-xfh.jf.intel.com.notmuch>
References: <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com>
 <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com>
 <20231110220756.7hhiy36jc6jiu7nm@amd.com>
 <ZU6zGgvfhga0Oiob@google.com>
 <CAAH4kHYPAiS+_KKhb1=8q=OkS+XBsES8J3K_acJ_5YcNZPi=kA@mail.gmail.com>
 <656e6f0aa1c5_4568a29451@dwillia2-xfh.jf.intel.com.notmuch>
 <CAAH4kHb7cfMetpC=AYy=FjTTve6g0W8NZdeSwQ8uVxkqi2491Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAH4kHb7cfMetpC=AYy=FjTTve6g0W8NZdeSwQ8uVxkqi2491Q@mail.gmail.com>
X-ClientProxiedBy: MW2PR16CA0045.namprd16.prod.outlook.com
 (2603:10b6:907:1::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ0PR11MB5167:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ce8f1d6-995f-4034-8a21-08dbf5cdb0d2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkQZvQCRreMQlOf+bqT0H7VuhqWPLdED2qTJOc6QfLHN3hwaDYM0VCwa9CDJnJe68WkvqFepQyWQV9PSy5Ei/xfCbDEHGgOQIKA4bzwQexz3xILl004/fzHjfPMM6RJ5OAthjIq+3OqaRlnk87fJ7lYQ9wOnc2h4ISUKJ56IEcFmHQyiQ6Qx2wi9OGcPhpSjHPYgT9DC1ZP/hVL8/gqP0Akk933QOGPae+KGTQ8XhlynWGsKPKGelJe5dLHoiu8TSOCdaFFkFtmnCrd7klLIWuOQ6nJooqrBE46Ji2GX3GiJ98/1kirGe6Lqa18ZeLxM8vOIRdVjxMplyfF9ExtzBrk4S4lmZCFqguEOqwZdJ+GVy3dZJ9aTN4fHv5SlLKD9WXPJRlmfxbqEQLFtepGFv3DjEqIw70DpZGeVxhoJ5O3/Ve9n7JFTiTZORMi6fdeMbJbq7b9IHeGSCOIHEBmpfdRVxhz64H5TbFZjc8RvalKsInzoZ8GWQGe1eP2JfD/MnCA66WKWrbZGRbN0nWzxJRTAe3hXGlq1lHJ55lpuENw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(346002)(376002)(39860400002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(26005)(6512007)(6666004)(9686003)(6486002)(7406005)(83380400001)(6506007)(5660300002)(7416002)(2906002)(41300700001)(478600001)(966005)(4326008)(8676002)(66946007)(66476007)(8936002)(66556008)(54906003)(110136005)(316002)(82960400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1yfMlUMOLIIrk59SQsDs835gSkScZiEOLnRTQUieyNjRTxqBfLnLxestWvYL?=
 =?us-ascii?Q?cRqzJHb/axSlDGd+xStLJWflfIYGn0B075qYi6mv2qHF7aPY7r0bReZeqRj/?=
 =?us-ascii?Q?+IWX9KBBHDZTV9900smx8ItaqqMm2VhdBTFakcP+H3ZLqwmvQLmv7rA0Ddfo?=
 =?us-ascii?Q?+PRn83+upF6N44GZpVaJHCOK/GSJwrnzANRDr/9Um+18Jh17gqfzQ+uwQKwc?=
 =?us-ascii?Q?YLhHOpE0pQcbv+xnxZ9IMOhV+HwQEgT+5eqQ19NOgXd2RrfNGeqYizvwTcRO?=
 =?us-ascii?Q?Y2ZC8TfMTS94y5hR+NfPMD6wKgGkInXZW8IusLXizH/MpKSxLJkI3Zqzhb0J?=
 =?us-ascii?Q?5DAmg14XP528o+NDff+3VYgWSDsY9H311y1TNhikfWvWCMrJNqZ0LCK7j0zp?=
 =?us-ascii?Q?f18WizWvtnIJOkqIF81FDuLsG+CULgb+hWWW6rEwUEdMNVd6/zK18qoHPoLb?=
 =?us-ascii?Q?EsL/3wTcmdvYHt4mdbCkBjrimsDTFhWZYXCDc3u3Vtj9vXa4PqoAH0B9POau?=
 =?us-ascii?Q?ZXHaU81H2dY3Nmdy818pRZ5IHaUbQA2kVdeJnbfLy+5flMimcvqTX7d9u1TX?=
 =?us-ascii?Q?FPSGnzeg8Mve2hq4wK57Oom02Ind0EyhBs8oB77aXF+rTULBdk72ZYBl9pfQ?=
 =?us-ascii?Q?zL8UieaiFF9lVXjhriZUb3EzuGkwas+KO0mIXlQ9kgmf7GVsIa0l933KNQre?=
 =?us-ascii?Q?0sH5aREGaG2HfG2lpS9aJPRD2DOk5mhe0akszxassZsrBeDbx1g1fmrC0heH?=
 =?us-ascii?Q?ZJpHqHVU1if4JLOMfgjCJqWaugx4Aq/Hq934H2W+TNMewU0ZFx+2jMCegU8e?=
 =?us-ascii?Q?3CrDk0vdvKLQ2rN9XEg55X2Zs92mFBm1ntqcT68uN+ezMY+pIhsYzywt3eUj?=
 =?us-ascii?Q?WUw3eJL/p0G5v4pgCt/dRGu3gqdXYEeprXdYYwQSf/i2vwteLcLP1/AVmtsO?=
 =?us-ascii?Q?56HHMI3WbacqMGVxc5awd7mqI/b1TrzZjdh30aDYI3s++7O+ejwnmBYAhh6R?=
 =?us-ascii?Q?+r6q2tlfzZNdi8jM96+zFI027z9Uolp+I+9Ij0usWX49aqap09RlwJJ2VZ+d?=
 =?us-ascii?Q?NALdGc6Hhncb1e2Q7O1ZTW92iGIuUQ9gSCTvHSNFLwdJkHR0jyGSgeaPvnIN?=
 =?us-ascii?Q?cdr4RWahznsQpC432D7Bz75CszMy0kMWGXKSS9qj6C0o3pjewF3LmzFU66sS?=
 =?us-ascii?Q?WFWpEV+uVTel8/khj8kabV7bzwSLa11KhIGIYaF1G4Fom1lLbd0QpX8lXyxd?=
 =?us-ascii?Q?mGr4GAyBfoCMe8wJ0Exzh+GVF+IKG6InNZ8oCwEVcokzDCjOS6qxwFZjiBDp?=
 =?us-ascii?Q?oUT0qD7yUuwjr1Wvixi8pcH92uxXseb5zfUs3wXVSotUJW2UAIfpZb+9TCoV?=
 =?us-ascii?Q?Bml8HNwkWbENr/D43gH87SxIDFjMEBKt3XmF2cEfc8NKRoUiZch5TNR84JhX?=
 =?us-ascii?Q?cJY1PbZbADIJJsnqUtZ9pu5WuJv5egeTdd/ywAtUemaTs6HbdOSg4fA6vepk?=
 =?us-ascii?Q?IilZ27naokqvNv5aam0agVnW3e6duudbm/oUVPbaJPXhYDo1MfFBb+KIezk+?=
 =?us-ascii?Q?b1krH53FoQrIoroxRQZbZxPAUESoo9r9mPztBtXcUJeKTkHPMXlCnktPGT51?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce8f1d6-995f-4034-8a21-08dbf5cdb0d2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 20:06:39.1311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Te2ssBNr66jDI3RtjUytIKQmv04SysmLXqQqWLIQ42sT6/eGSMVDuM53R551BFC1CRlaR11/1YkGi19q/jtusdkGw5PxR7SFbz6TVzv8Fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5167
X-OriginatorOrg: intel.com

[ add Ard for the SBOM sysfs ABI commentary ]

Dionna Amalie Glaze wrote:
[..]
> > > My own plan for SEV-SNP was to have a bespoke signed measurement of
> > > the UEFI in the GUID table, but that doesn't extend to TDX. If we're
> > > looking more at an industry alignment on coRIM for SBOM formats (yes
> > > please), then it'd be great to start getting that kind of info plumbed
> > > to the user in a uniform way that doesn't have to rely on servers
> > > providing the endorsements.
> > >
> > > [1] https://uefi.org/blog/firmware-sbom-proposal
> >
> > Honestly my first reaction for this ABI would be for a new file under
> > /sys/firmware/efi/efivars or similar.
> 
> For UEFI specifically that could make sense, yes. Not everyone has
> been mounting efivars, so it's been a bit of an uphill battle for that
> one.

I wonder what the concern is with mounting efivarfs vs configfs? In any
event this seems distinct enough to be its own /sys/firmware/efi/sbom
file. I would defer to Ard, but I think SBOM is a generally useful
concept that would be out of place as a blob returned from configfs-tsm.

> Still there's the matter of cached TDI RIMs. NVIDIA would have

I am not immediatly sure what a "TDI RIM" is?

> everyone send attestation requests to their servers every quote
> request in the NRAS architecture, but we're looking at other ways to

"NRAS" does not parse for me either.

> provide reliable attestation without a third party service, albeit
> with slightly different security properties.

Setting the above confusion aside, I would just say that in general yes,
the kernel needs to understand its role in an end-to-end attestation
architecture that is not beholden to a single vendor, but also allows
the kernel to enforce ABI stability / mitigate regressions based on
binary format changes.

