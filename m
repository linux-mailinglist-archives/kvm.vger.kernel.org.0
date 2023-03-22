Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F196C5AC6
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 00:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCVXpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 19:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjCVXpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 19:45:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A58730B09;
        Wed, 22 Mar 2023 16:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679528688; x=1711064688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hOypZvH+7aUAFOKCCVdUuUVzijLyOhijQLG8Xt4CSAo=;
  b=E4bBS/rPMb0HEOKwZr00imdlR55PYTcaPnCURWexffmNPApa+iiavlbT
   Kn+09nWw97mkqTjmVKBIIVg4iuTiWJ2xN5IyxYTc/WJ6aKWmMBB19e3NB
   fOFNWpXGwIyZnqNbX5YGx4IJZsX6nBjyeEMcb4m/x2Geiwbdjh2x9B8aL
   gmiqYPRMFCSAExDhK2my/mXoPt7DkFjMPnZZZg7GQ3UW94nMDeqX+ArzX
   Mj/xF2gXhSpuJRvlHF3ogAEv05wVlPo/2CHai9oe9ZrBEOv2KVNvUH9zu
   +S2sHXOYX3jpGFjOB8vUmYFYQi2XKZDeVi17S42qVTOr4CCUCvobM5KTx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="341717115"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="341717115"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 16:44:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="856291258"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="856291258"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 22 Mar 2023 16:44:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 16:44:17 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 16:44:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 16:44:17 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 16:44:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLCsXfBqHBTT9En/DMc03ABcc9iSDBLWK/mW+idfGwf2vqx81XE25e4mf7z5I4rkpOVtfBFw9wc600DX6w+XQwWGDReSyCrgH7vFZUv+trdTSlxBd78Y2lgJZyWFraO+594ZJC+eMdI2DLAZA/blXuiDLUPfDR4EWNZE4GWPe187/0hRFrwBsutuRGiFuoMuKqHAdByTXxNJxCjL4ohNv2csM3zwxAp0+jK9bh2JZ1Bmh5BS381hWmJaD7/O5Dcttjpf9ldWJOesUq/g3eQZ41h1ont74dBviuoZLl3UErq3ZEettYLj9ep5oPFulRVVaekPkWZcF1SSFYx0+q0qsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBfjSQyQaxWfEGXIEOasjA+V1cuWtRDSDutfeHvp2k4=;
 b=ZaRw/OLmNgbB4BbyW4n5V2fF7LZ94Oxu/Mnhm7yeD81Thl5OYkWJfZX6GEL5UEFwqwXqdbtjPChLiDJgVqj8isZWFK3HPeZg4JNWaXv/A2ciytsMvfLyqTLbHLKKEt/6AU0zsOYrTXIg1VOxGxpLMC9TL8nlhGa935UPfJom8MfwuMuEFJjBj7BcL48uN3OFfh3eXwW/fYBnrbztt667Y62m5R198ojExCK+Ccp4nBaJOjdJquz/XODdsCMYyOXlfk0EcM2Ad/cAeE5gaG2YFJvWV9FoiXTXCWT/y6GJGe5oMAlWRoquuhXVXuFol/sIE3bSe7kv1PHpxJLMziCN3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SA1PR11MB8349.namprd11.prod.outlook.com (2603:10b6:806:383::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:43:44 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 23:43:44 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Thread-Topic: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in
 NMI caused VM exits when FRED is enabled
Thread-Index: AQHZUKI3WfAyEb/jCU66DZKXu8CGnq8HLBKAgABdmPA=
Date:   Wed, 22 Mar 2023 23:43:43 +0000
Message-ID: <SA1PR11MB67347752DDDCB7F608003C0AA8869@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-35-xin3.li@intel.com> <ZBs/sSJwr7zdOUsE@google.com>
In-Reply-To: <ZBs/sSJwr7zdOUsE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SA1PR11MB8349:EE_
x-ms-office365-filtering-correlation-id: b3d21297-60e2-4d24-fe94-08db2b2f45da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lZDAJqitrRjvnkjoaHF5zNFXeR1XlR5r5aziIIRl7JfC/o0es9x1CoSIMKZqwGHkuc1rikEb2Z8zchDwv6XbaTTCUmz1/LtwLmardoRYpNKBM4lnOIf61m63U+bN9D4XG1w9ZZhaIOANeVGGmbzR0KUGCmmWO8ArPxy1GiYQOQFg8ZhWUEpxwSCLAtvpinV6j2RFb5Yl6Rc4WwOD2SjFEHD42jq5APUOJYh9+O7EaPZsvWamaL6nw+M386mVbzyVMzUt8yC6llCyGUGdNiibXJyz9KgGJDF1Z+FB4CLCfSM2xE4ZGtnGtMBnXhAW659ZY9oYW5jQ8ABWejm+xmpgyLS/AAAkQYMv64k8GJ3l6/kkX9hL5L2z8u+jvCYr9tcR+mj4irB2/ePervh3ezWQcyYez5BfkjEqXsjdofBCEtQak/s9S0Ji7h4l4BOlJzX1CKMKxr+Ja/mr5hZ6pxQ8ZO73kDU3MQPYesVLRkjRR2a5ZUKtibOBOUN2Ef+MyRgw0xP0ChZ/aeFUD+lDF9X0i1/4GU1OYVAI7PrxJmq1HliiCv4Lu9chohBfx1gRVnWmt7xpHZbkZyU/QFDsmbrpf2fOVuZM+ZIXTFCmsJaS6oEVmdL0AuIBe5LumgDd8ApcLb0K6Qnixn4BQjUKBB2EiUH2XDhjI+1xDGSCaqRoWlmLJQop+cOe+vEt6X8anvw6dY1R77i0pVW3YpaVgW0jMVlKUO0HSGmmb6QoKvkti7o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(82960400001)(2906002)(38100700002)(38070700005)(55016003)(122000001)(7696005)(83380400001)(71200400001)(966005)(186003)(4326008)(478600001)(9686003)(86362001)(33656002)(41300700001)(66946007)(66556008)(6916009)(66476007)(8676002)(6506007)(76116006)(66446008)(64756008)(26005)(316002)(54906003)(52536014)(5660300002)(7416002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5p9jYLUbjBOr1xsrcFZWmoYxvwoEatnDe0f/LsLh8mVFk3cadkA03jWspWlu?=
 =?us-ascii?Q?sz5T+lHXf+xm8rRRKmCt7WGKB/+BPyU7ovkhse/kqRfmyjWU5NvQvH5OQSha?=
 =?us-ascii?Q?CMSx8ijv0ThcNdiDIoO5J1e7y/7lfoVBp9oXe1mN4QTollep9HZBXAgS8iqc?=
 =?us-ascii?Q?ivWw/nMb/9k9ZBE/Fz640yOsN1Mtc+avlFrPMEY/bNiVD41e16fpZUq7aD2o?=
 =?us-ascii?Q?E4V3HlTbj1XoSwUaXQbke0V9VJDFQxxVeU5rlTwYLU07pLRHOqus+HXtBgo/?=
 =?us-ascii?Q?Q8Q4/ZdcHCsz34qDLHx+3TgGcSaIJV2lJ5RgF7pIj3iCUIgsh1pIBglmUKN6?=
 =?us-ascii?Q?n4QbiFs0pArxlJn7QHu9ym32Dgw7wedyAcToRgSvTG5+hDApLPUxyI8+1xqt?=
 =?us-ascii?Q?62wlADzd9Kf8Ukyq/QZz11KoH97uko620z7+f7iNROSXghmeRYeE7ZMycFkJ?=
 =?us-ascii?Q?YGGgXGssjyrMIDWKX+c7qQO+7tYSicWEPaqG9x6yOXjlftajT9kb5aRLbb/D?=
 =?us-ascii?Q?bLjcEBgbAcpxArS2CJA3Bb9lRxZDxymGWO3pckgsle1RaipNPg5mSeZpb3Bl?=
 =?us-ascii?Q?udsNbDl0crpEUPyeZtJyk0xPwlEuCc7CytAXTgoPliLnLa+kdLJMPFrUaNhQ?=
 =?us-ascii?Q?pMI8TRrjMKsDxp7rh3bbEaZBkxwlrfSgCgRz6UJ74CL+wxjxVdNBPOYppcOy?=
 =?us-ascii?Q?JqA/FVeT+9+xN3x2Bq6/yLCLfl40sc/A9KBVXWnpMxB+8LyBG1wlRhDj5TUw?=
 =?us-ascii?Q?3QrfqkT0SCXci7+63GnWvegltmSG3IJyvTu9Wddsjjg0gV/flnfn8CAwiGUH?=
 =?us-ascii?Q?oMLjLXqGF5h2YuH+DLiyAFdRr2PDV768ZAKHCYIRkNOeYv/Jo1eG72qZplu0?=
 =?us-ascii?Q?YYAzY98UWAHZnyDPQyNUoPTpdGLUbvpCuLVKTv/qOTltTGvt3RXIN1g0LPzm?=
 =?us-ascii?Q?YB709prGHsBrZeSK4dVPJvoGNP238mdVXteVRfBWgs0fss/TX6AEhmg/M9S0?=
 =?us-ascii?Q?+XzB6iBK9NEcUeQieOP5wZTPCaG1xBB1y0dAGbWQ60Wv+gOTwCj/Nvz3VBq8?=
 =?us-ascii?Q?5d01FAPGCgFiMiE3kXnSeT4N4OK8D5rbpZraSJ9X3/nxW5GIafeB3lnCuZVN?=
 =?us-ascii?Q?pOjnZags134L193ueDWUrP0KvNFhP9jo+dI1wG0/PS+j/QN3MKoIosLs4k3f?=
 =?us-ascii?Q?5a1iTMEvkug7DXxQfQPBp1//Ohevf3qnjA0FSnQhRRKx0hPUgj8c6oLDZgmn?=
 =?us-ascii?Q?EBWN0LHw6rsNUxwbtKEIbu9Sql4M6Q0FwR0NC7aYjaPP1mmvvuCmZiJebtQ/?=
 =?us-ascii?Q?BAV5Ds4aaM+tlOKK9UDb6NyAy0PYEikZwDtHYEImtwitq/J7JcS50lK8325Q?=
 =?us-ascii?Q?wlhDF/6hHdCKr/cn9tA7fEm+qMSkiy4doNMvpEfFonzc4ASspBh/pqIDErDc?=
 =?us-ascii?Q?zAVWCVYgZ8dO0BHRDWBQbamMx2aIUeG0CDpiGd8QUf2ek8PPY4/p4P5ymtwe?=
 =?us-ascii?Q?vEpWHfY2nn1Dxze3WjjONBpUgotGyY9oym3xpckEansDtkwJZC1fJ/p+766s?=
 =?us-ascii?Q?6tcCtPSVBDpKdt6rOVc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d21297-60e2-4d24-fe94-08db2b2f45da
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 23:43:43.7869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LJVCbHmcLOoLbxssVa4ZAcH4xdOvJsCnbUHv0vopou1Zpfa4tuBs9VoK/G8x4o6xgIc4rpfFgXLs/W1kUQqRZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8349
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Like IRET for IDT, ERETS/ERETU are required to end the NMI handler for
> > FRED to unblock NMI ASAP (w/ bit 28 of CS set).
>=20
> That's "CS" on the stack correct?  Is bit 28 set manually by software, or=
 is it set
> automatically by hardware?  If it's set by hardware, does "int $2" actual=
ly set the
> bit since it's not a real NMI?

Right, It's the "CS" on the stack. The bit 28 is set by the FRED NMI handle=
r:
https://lore.kernel.org/lkml/20230307023946.14516-20-xin3.li@intel.com/

Upon a NMI delivery, the NMI bit is always set by H/W. However, "int $2" do=
es
NOT set it, thus we need to explicitly set it.
=20
> > And there are 2 approaches to
> > invoke the FRED NMI handler:
> > 1) execute "int $2", let the h/w do the job.
> > 2) create a FRED NMI stack frame on the current kernel stack with ASM,
> >    and then jump to fred_entrypoint_kernel in arch/x86/entry/entry_64_f=
red.S.
> >
> > 1) is preferred as we want less ASM.
>=20
> Who is "we", and how much assembly are we talking about?  E.g. I personal=
ly don't
> mind a trampoline in KVM if it's small and/or can share code with existin=
g assembly
> subroutines.

I ever got such a comment:
https://lore.kernel.org/lkml/8735bpbhat.ffs@tglx/

However, if ASM is also okay, I can work on it.  And I don't think the ASM =
code
will be big.
