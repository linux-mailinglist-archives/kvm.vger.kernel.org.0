Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404C74E4B87
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 04:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241560AbiCWDh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 23:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241553AbiCWDhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 23:37:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862777093D;
        Tue, 22 Mar 2022 20:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648006550; x=1679542550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o5Dr8IiC1ocOvSPHem1Sioh4b7U35QV3IUqt2Im329Q=;
  b=EwcDhh0vt9aXGK0UNflvzOAUFzjTj3gBxuOK3OBHxTcTtLGOVVRowQjk
   7M2q2sCqxlYQqXkb2pXJuf7gtPaIqBv1L/gm/SguddBZYLlRop3ORVKjT
   LKJwq75D+a/URmB28jNNpPzQvhwb1e0ns0ANVjIz9nPa0K51PyjeDZwJa
   OhQqumxYQYAAvwdhlKvs03+Ze/Gw/amouUXY3qbEF63VWsOJK4yRNFRP1
   uOJT3RxbV3369Pg+08VoFOlWVyMRjcMi1SLE89XZ0azwNeyUdxQFQbBlW
   isMzKeUpr7GuL2At75f4byaRE0JuzxYsznr2T7Shbuwt++3+C3b9Et3E+
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="258203049"
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="258203049"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 20:35:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,203,1643702400"; 
   d="scan'208";a="717229609"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 22 Mar 2022 20:35:50 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 22 Mar 2022 20:35:49 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Mar 2022 20:35:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 22 Mar 2022 20:35:49 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 22 Mar 2022 20:35:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwSM01Km8gV9TKXd0vNVrr0UU7Vx3an6MYihFH9a3qPNSZg4uxRzebL9+Ig6X8wy0Yg9vqHm8M9VmtzlLAA6D7QAjf7HL7bR6PgF4mAdZAf2FHsmLdirLTM2eGoCOx2EdvbDDWGXTRZs6lZ2Ep+PIKNvlDFi8ADZnkXgSxlhBgpJOsruHRpNo+jWLpCzimz/IHWTTRFBtbC9H7FHya5j3uw1mpSOEKrbr1mVVjF2JAGY4TImwWOGtf2EZQhC8OdEvNl1jitfOeQJziwyTBDEmWFaWkTO+lx431wVnZEj5s0am89Z4+Zo4epfMzjHiaQsrdOb/6NZ/jz5EZGaprpuzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AJaLvnW46AddKRRZAvRayy7DZpJWC5Dy3wcI0qxSBHU=;
 b=IPPmfBnV90NCuheQBT1VA29pADWGdPV55MESXc9YwQrBKPlRt9zNgKAX6rh6v30LcGV5VDLPKiZYy1Teme07tppgeCjVqgrRFcWXYrF+gQibl3Rpd0lykbmGJ0PLgaH5g+/UNtPN+no0IYT4Kg2th+ha64McobPJooi7s5e0/38JPKAkzaTHb8V/uYyDp5/bqNZDnKjbA9tzE+G9gtUC4byYUgVmy5MNvdK70ibh+FrrQe2S5ewRRE85c62SKT1h7WS05HIAKyynhoJwlQMCrJWCWdhhrHGAVh4pAWGKgwTgtEUqnEofPBSZsQ1qSnAkSX39aObe6yr583cU/lMjMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4580.namprd11.prod.outlook.com (2603:10b6:5:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 23 Mar
 2022 03:35:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5081.023; Wed, 23 Mar 2022
 03:35:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: RE: [PATCH v2 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
Thread-Topic: [PATCH v2 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
Thread-Index: AQHYNsg4xFkq5zuN7EW7F8EKAI7kNKzMXTdA
Date:   Wed, 23 Mar 2022 03:35:45 +0000
Message-ID: <BN9PR11MB5276B5986582F9AD11D993618C189@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
 <269a053607357eedd9a1e8ddf0e7240ae0c3985c.1647167475.git.kai.huang@intel.com>
In-Reply-To: <269a053607357eedd9a1e8ddf0e7240ae0c3985c.1647167475.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17aa54f8-edc6-45ff-27a1-08da0c7e36ef
x-ms-traffictypediagnostic: DM6PR11MB4580:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <DM6PR11MB4580460162FEE75411D096B88C189@DM6PR11MB4580.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r7abJ6JNb8Q8VsX9WVZI9RldHRB7tC/5ENAzP6s4xak0cHmSbdrj+zqtbZ2SR6SuACuQloT8CfMvr/8/gJKdxQ5v1aOz+/aN94udSBzKDI8Ooo5JXA3WN7WAd3kojHdYlNUFsvAdSqI/roVLph7ucTgAOTEiiZMO7mCtDXhrwfzXxVMHSdHAbLPTyaKxGvwNxlirJLQk9Ps53JF32442ogygirfVgDNlMqotCEK3TMnsC5bQF7I58LQjnrJDt15gBClSqVLC4gx1SD2gIttulyMT+QNDoX9dHYklqqb0N92lNmdcwyFRr7ftV8786s/Iejhshoqobnz1PpCzzSSfxbPn2nStOyPV0tTZVizPojOY5uNNALE0ODK24LBUjdn47nqYUYZJThPrL8gq9r7jZVzBx3BZEYhcF5jc1sZtTB2excnJAo6zxzgeK3z5/9ONwd79RgyiHBZPCQsfxzSCu/BhFkAcdAxlVS7OVG6Bpg7k8bQ3kL6kk8Zsr4Qr9Q6Y1kZ8Ru3JIap1tTFr3XQwNsienj7AfCWZtyBBYcWW4vQ6BRsS0y5nwdqZStVYx9d3jNvpaXUMo/LUNDPAOu4zZ19W4nsCxie8Ja/vnXRI1GdQA9fn2iSG+LQj6NtHA0jYI7jcptPwiDsAsB75P79rhdrBAAIB0z012A/w+6RRGJhQ3vm8ZXu0UNA974x5XC/5uTAIJy84fzu18kUcFJa4Bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(71200400001)(316002)(26005)(83380400001)(38070700005)(55016003)(186003)(33656002)(66946007)(38100700002)(76116006)(9686003)(7696005)(110136005)(52536014)(508600001)(82960400001)(54906003)(2906002)(86362001)(6506007)(4326008)(8676002)(8936002)(64756008)(66556008)(66446008)(122000001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4QVLJ4SK4HSoGtu6T7Jxbr4NiDFjL7O0KQkvRWW2ApGouPBsV55J7ffbepwU?=
 =?us-ascii?Q?29iS7kn8v6OD5NVUr8bDSqRxke01PN/DbpmEzNLCA6Aa57HEMimiMN+uF4Jd?=
 =?us-ascii?Q?b02chi8RzmwSBuCXGOHTXEOQviGn2Og04MlEDIZKfyYQsRfjErkgz/R7h3Zy?=
 =?us-ascii?Q?8elB9/cI94bS1F9xBuWSQsP2GIXYnot0Gr1QT/kQVWdRiUBOTDe6I+HRa7Wr?=
 =?us-ascii?Q?Osc1ELwWTp4cUSy+sqxOPVoriu9RY7bzT8ygBP2j/nET3zcoHQRV4kFnZeWl?=
 =?us-ascii?Q?ed3OV8qVKyThdXUjbGqtk6HlvojZ/tye2T+u7Lf3rOqdUVg1ZcMyYHCjfaCF?=
 =?us-ascii?Q?zn1N98OvgfyrFvoU7U8hX57DtbadKYgt3oNHzCIy1gRyjpvLG6VYsjI49eVQ?=
 =?us-ascii?Q?pJsgPpqdnjU4mjukiQHj6ZkAOFPBa+LkNIJ3kgIhPLvXiJC4381mmcKDj9Hk?=
 =?us-ascii?Q?x8o6yGO/Nu6LDXTGazPBaTX7N7mqN5PvYaCcXZamwZ+sKfnit41zyGjqRMRu?=
 =?us-ascii?Q?YcJL7+ny4WSO+BkjgJNxzGiRXZ/jEf6Iyc4vDqfW+0E1LaBnc+AR7lFx0h+M?=
 =?us-ascii?Q?YdZHOa00j+whvzi+Q1DxGv+ceQViRWq0GPUoVDQQkofCIbD3yUazNMtQh/qv?=
 =?us-ascii?Q?mtnQxIyoA99gakreCNHW+uKtIhuYPqRlfEtXWyy1N2ME+KRGYxKmlm+ybYQW?=
 =?us-ascii?Q?G7rfjW46iXis931h0agpQxdPCQoyLw2vXmWL4Vywb3YVmiy7LBIojn0oUHOf?=
 =?us-ascii?Q?H11KVzpz1MEuXVcnUuJfIFydzJ8MAWipIMjfNTtHSLwXg7YdNzqshsJiEYh9?=
 =?us-ascii?Q?igvsBd67bW6ftRnZgCrrLxyPWXsXaVa0HZ0wOA6m9g+SrRtMqu4MR8yV2dJM?=
 =?us-ascii?Q?Z1VBlk46Z6a5FJOe4DbpmF888P6cge2AGeB/gNnPQ9MqOAGEZE6293k3f/Bx?=
 =?us-ascii?Q?eSrbjd5nwvJeZUq59S733OYEFkrKPNl4k3+0Gp6vyJOI5U8qNjJGcTHze7DJ?=
 =?us-ascii?Q?CV1VngrwyJwzwkvuc5pmmlNFg4pZ0G/PgLKJuhn+p82qQOmD6aO6jYIjtt+C?=
 =?us-ascii?Q?nFD9lX+vojvTOoYOPTvDHE1CI6IlsM1JhZmXnksSOedOpILyjQn3wMNYxptd?=
 =?us-ascii?Q?+Qdxhc28zK7WwOLoPW67SixQyKuZkfiIPevZI2x2lqfQGs4c4laI75rJkG/j?=
 =?us-ascii?Q?3sPEmWXvFlyno5lpta6N4n4fhrQghXWGN04OvluSYJxsuSkQRdaQO3DcBHpH?=
 =?us-ascii?Q?o0A88T7p19gwGipe8TR9JLkTEmns2zuvM/Td8uhjGXNB/o8/I5pauD6fOpWV?=
 =?us-ascii?Q?LH0xgRWzEyUyrF/GwD04IUEOpJnT+FFAg72PZ5mX6DNDK6w1NlTm2pMYDp4t?=
 =?us-ascii?Q?HAqXHOaXoweL6w4IK4Ggfce7kHfF+C502SwXkadokIM87KV2V1X+kwaujAPS?=
 =?us-ascii?Q?8ll/2NHzqgnqQsznQty0RcDeP1XqMiX6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17aa54f8-edc6-45ff-27a1-08da0c7e36ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 03:35:45.1996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +GXvvjOJAvF8dJ8y9MHmJFfGT1q0gFmJoNjVM/RW1egNvnChYf6c7BAte8P2F2bs5kKfjvVoxfCvJxo94Rc7Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4580
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Kai Huang <kai.huang@intel.com>
> Sent: Sunday, March 13, 2022 6:50 PM
>=20
> Secure Arbitration Mode (SEAM) is an extension of VMX architecture.  It
> defines a new VMX root operation (SEAM VMX root) and a new VMX non-
> root
> operation (SEAM VMX non-root) which isolate from legacy VMX root and
> VMX
> non-root mode.

s/isolate/are isolated/

>=20
> A CPU-attested software module (called the 'TDX module') runs in SEAM
> VMX root to manage the crypto protected VMs running in SEAM VMX non-
> root.
> SEAM VMX root is also used to host another CPU-attested software module
> (called the 'P-SEAMLDR') to load and update the TDX module.
>=20
> Host kernel transits to either the P-SEAMLDR or the TDX module via the
> new SEAMCALL instruction.  SEAMCALLs are host-side interface functions
> defined by the P-SEAMLDR and the TDX module around the new SEAMCALL
> instruction.  They are similar to a hypercall, except they are made by

"SEAMCALLs are ... functions ... around the new SEAMCALL instruction"

This is confusing. Probably just:

"SEAMCALL functions are defined and handled by the P-SEAMLDR and
the TDX module"

> host kernel to the SEAM software.
>=20
> SEAMCALLs use an ABI different from the x86-64 system-v ABI.  Instead,
> they share the same ABI with the TDCALL.  %rax is used to carry both the
> SEAMCALL leaf function number (input) and the completion status code
> (output).  Additional GPRs (%rcx, %rdx, %r8->%r11) may be further used
> as both input and output operands in individual leaf SEAMCALLs.
>=20
> Implement a C function __seamcall() to do SEAMCALL using the assembly
> macro used by __tdx_module_call() (the implementation of TDCALL).  The
> only exception not covered here is TDENTER leaf function which takes
> all GPRs and XMM0-XMM15 as both input and output.  The caller of TDENTER
> should implement its own logic to call TDENTER directly instead of using
> this function.
>=20
> SEAMCALL instruction is essentially a VMExit from VMX root to SEAM VMX
> root, and it can fail with VMfailInvalid, for instance, when the SEAM
> software module is not loaded.  The C function __seamcall() returns
> TDX_SEAMCALL_VMFAILINVALID, which doesn't conflict with any actual error
> code of SEAMCALLs, to uniquely represent this case.

SEAMCALL is TDX specific, is it? If yes, there is no need to have both
TDX and SEAMCALL in one macro, i.e. above can be SEAMCALL_VMFAILINVALID.

Thanks
Kevin
