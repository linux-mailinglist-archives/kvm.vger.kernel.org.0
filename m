Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40587330D4
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 14:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345210AbjFPMIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 08:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjFPMIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 08:08:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE16295B
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 05:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686917319; x=1718453319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BQqOMb8PyPpLpQDVLdpMvWBNPY/3dpP5YwvlfBKLd8w=;
  b=RBJE4zaY13kTp+E9e8x8//ZxXe6roGoOwWBRAki2m5bkKZqw3saGqWA8
   L9h/ElOImNOByK5yr8OFx7sEGVrsbfEwgwWA6nSy6UwXy6r7HEiPM/aHc
   UsIVxCBhqSVugNUS818BTaqVA3lXi+R2OFwon0iy8cxFxVEyXe7rq3wfu
   /b7jUXslRYgSUA55U5l/+DSC14o3U7Yq7srJY3tEyX4cU2lakG3BmQuW5
   WojnsRTzloa3WrOUPEkO4zzCqfl0nYNTCHfkMZWQ2Pm5CY3Vzz2RCQ8R/
   RWjQqhAYHf+a/M5aSbbDKvL9bAW5ZZ+F+/oat+NyFj7hVw0J71D/bPSzD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445581308"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="445581308"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 05:08:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="857361923"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="857361923"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jun 2023 05:08:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 05:08:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 05:08:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 05:08:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 05:08:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zy23lbZRxv6acHUuTaj1nkmaI8b1twunolZ6aUAPPbknPqleU5Ih7CBYr/AvZ+lvB60VawXPVQduHpsactFnAgn492ulg9fhxzyTPAZiTceemqlBM8VH/RPd7vBXnyTrpiIeQJxJ5RyKD3/dVHOgSmaLkl5xMw/pZlsZt8PhaYbo7XmoeB/OdgLLWJ44N4rjkcUrmJP7LX0Rd1Jas/waYC7bDKSaYXQVoYYHPUn8UqFM4DPBSNw5Up/hmhRZLFi78iW9hDfZbf/KA3KZ89z7gTDu8CjZFYHZLNfKHV1IEUD5KMtVTGrjkv0Oxv+v6jA8SsysBd1vhW26ifSMk619JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLrpWUJsx8tyg+D2W/B0eU/X3SAhjQZJHGrV+QStav0=;
 b=asZ3aM0r6KbDqSQbpazXrFaQ9xn9C1yRKnAwDKk1zOfGDcgcBfaI5uK9Yp1xgOYOZLt206wcJAiSc8YWLAw5O8+/JD70XV/pSrlkysikM2x7LbkUmD3E8WwH5x304GdYIg9zg+cy3D+d817TCCMrszm6v/ju9gLaAnv+80FXEeN3jmrxVgMZxmvvuq4zpcwzhEFSbm3b3PBms/hsd9wb1s+YgittwELDq9UIpldu9u6CuvGgnMhl1I6R+wkQjleLvphQ4cjLQFSPrkxIEoYYHJq1dafHgqRd25L2yGLd4lnek+C43VX/aKiOHBTNtkGOaVawBZtOmBH61Q/O8IdCGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MW4PR11MB5798.namprd11.prod.outlook.com (2603:10b6:303:185::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Fri, 16 Jun
 2023 12:08:34 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb%7]) with mapi id 15.20.6477.028; Fri, 16 Jun 2023
 12:08:33 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     Anish Moorthy <amoorthy@google.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
        "jthoughton@google.com" <jthoughton@google.com>,
        "bgardon@google.com" <bgardon@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "ricarkol@google.com" <ricarkol@google.com>,
        "axelrasmussen@google.com" <axelrasmussen@google.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: RE: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without
 implementation
Thread-Topic: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without
 implementation
Thread-Index: AQHZlW423muHblFfrkaOENvhBA1a26+K4T0AgABrGqCAALvNAIABJmug
Date:   Fri, 16 Jun 2023 12:08:33 +0000
Message-ID: <DS0PR11MB6373C2EC8128E7C7D42FE122DC58A@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-10-amoorthy@google.com> <ZIovIBVLIM69E5Bo@google.com>
 <DS0PR11MB6373969DA5CCDD6EBBC9CB7ADC5BA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZIsmgnEneMBZ48hf@google.com>
In-Reply-To: <ZIsmgnEneMBZ48hf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MW4PR11MB5798:EE_
x-ms-office365-filtering-correlation-id: d701a65e-79c2-4e86-27ba-08db6e6267f3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DIwMACN8aXrffTJHmQ8aiI9Pp2HRmezUfc1EmTD7+hmJQSirglaI1ju6byR+YJgPWHnHtiOdhZLcHBAVnoc+YydKkxHbxY++uhXFZG/bxDr9E5H/rn8dbdJfsA2ssFaUq3pnr9mC84LuaKJFWIH0eD1I7hTqZTh2VjCE+RNxQptPTfT6nrQMlRHbN+pVLh2Rr2WY9L6G2BXzYCs8KbRJ6c2rnwijlz7rjaBZXiN/vGg6yf7B2QAkARXWjOQwBWz5C8dgOS6cvm6nSNCo789sn10Ko7BAWdMQ1l0MCDOsKofqgZ8km6ryvmBbswINoHdEde6wvftkxTjNxS8rOoNcFmxPDQnjDFPu9I8rSP6/aVNHJ13gocO5G8BmhOBduzKDB+/ePdsBwC7qacUrsO8sQfF3UvbOL2VL+YhsfXwjqt1D05GjWYMewOz7EiMXVFKwVPG+D+x7huNDszbJpIYZAvnvdNlfgEHJ+mwB1ohUccHkqFo8u3zxjsDy4nay9XQ45eSggigiUwjlEBYcePhVJM5UokFBMeAb3IDaGDYFl9X7OfmN6n+0e007E0lCyInWcNznUYdQ02HtS14crkpM0fzJ/VEMtNdduEfL30bMEeBB36dasUNx29iue04KMhK/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199021)(7416002)(76116006)(4326008)(2906002)(8676002)(4744005)(5660300002)(66446008)(64756008)(52536014)(66946007)(66476007)(66556008)(71200400001)(54906003)(7696005)(8936002)(6916009)(26005)(6506007)(9686003)(186003)(316002)(53546011)(41300700001)(82960400001)(83380400001)(478600001)(33656002)(86362001)(55016003)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hr9qEQ5n0s4R40BOlR3ab2MHLp00WflnykoYov6OUSEAZrtkptc4SMRUy/WV?=
 =?us-ascii?Q?96m96MlBM1C/X68AhDr11XCzV1iuwDpARmFKRUmokSv645KeMtsutLdd6svP?=
 =?us-ascii?Q?9hK+3RpnfOlcEOfw6HfNubny85RHmg310wqBjwMZ7xTMvbhCDKDLQBdM1y4J?=
 =?us-ascii?Q?JD1nSlO5WjXoDBsj9D4QVa9xMsyUJuV79l38EZ2YMjtmDXOPN+AErzbALxyP?=
 =?us-ascii?Q?2TjlqgT1sHJvk3tbM9ECkIpRVgRoU+KH1uzBv0sEs9j4kKf6jb8o/JxAzsGI?=
 =?us-ascii?Q?RdA0tbQkjh116wT2D0bOSBrdDhOh1b4trpOnXWl+GV1BSHRIMzdS/Y3OdXXg?=
 =?us-ascii?Q?H5U01mmN/i8HIGK/vOSGGp1cyShVni5zwnrbgcYQ7nSw+Q852WclaVCxfyC8?=
 =?us-ascii?Q?j5Uq2GCHC12POeuQOkr9+aMPcX4c9/QZ5brZv/Z+EsBjyCaNWa1PXrOMHqij?=
 =?us-ascii?Q?ut1+p8rjPrnLQrm4HZwjzBGOO81OF2tDsy0khnMd2XHsBg6Ag0hpipJp3BFl?=
 =?us-ascii?Q?ve0QpkIIHbVYD77tqhfW1+8M4MZ6yTK/3fm1imQ9Uh6MeYUnXY7hdMVKWIuB?=
 =?us-ascii?Q?V79B6C8khVFq7WglTmbLxmkG40tzeLTuJTjdwMIsS/dOaPpbvwKwgb7CPM/+?=
 =?us-ascii?Q?NDjNfQpg6QJ3UF4BkADPL/FIYIJNWOZRAt7v2cITVZ80poqBSfZ7CcizAmN3?=
 =?us-ascii?Q?rHhynlxpRutHeYi7SS7Oiy45FmVmvsIA1WT75fd3V9tJxhM3kIU99IHoerlo?=
 =?us-ascii?Q?vZueMy8K6Zb2m4gn4uDxQaADJgqBmF9DSqjh87txlfDJciSJW7MxeTqEiJ6m?=
 =?us-ascii?Q?sE3R6vlW8ykQUdbq61vMrkEgMDyZHu/Zivjt8n39KRk99GtfHoNK8z0UIQPJ?=
 =?us-ascii?Q?YI9aLPdJptDI2Z5iiPc0QJxEOvrQ27H9fiFBKUT2oyvGl/mywDDFyoYOLZ9V?=
 =?us-ascii?Q?QVSnVlbezmFxivAFMtB1f9WOcWI8VDS+cMZ4XjQEjzgBMoNdfMwbOvO7cAV8?=
 =?us-ascii?Q?ZRD5MSyrHTIZ2/iM+XI+HbrwfnOqoj+MOxI9N32ZsbuVV6yLjb64yh5knn/n?=
 =?us-ascii?Q?j60dvlG/RL0shZuDkqz/0Cfwx2+w8XazyWs5B/VQ/FoNVBfKxPC2k+Un69mF?=
 =?us-ascii?Q?m4dUxmO53KXSybFLhJt76LseWUL3cncw6y0Yo5Q3TzwrpES/w322kyQi+S6N?=
 =?us-ascii?Q?AIajwouik4d6WBggWBB530RJ1eVe8IpGf6JGKX3Y8UYYGHe8ZwJrNxOb60rN?=
 =?us-ascii?Q?5M99Z2SGZ+EyyUVAzVZLgPBnH5XRDqa6zdAtzdZVulCyPRDJVM+/s/iyc0E7?=
 =?us-ascii?Q?5RvtTc5TwFGRhDlTIwn9kcibEVQtQYywanbWL2gd4tZDqYYcT06TcaB6VovA?=
 =?us-ascii?Q?GIvHmmNHlO8LA5Av1MnSVUlnWiiD3xqwqTjq5uML+lFcXUWnUlQH5ySDOOra?=
 =?us-ascii?Q?zRCBGGzJCJCMEgJ3dw72lzW3g5tk53x/W3rVZzOEodZ+7d02EcZ3g8AusdNH?=
 =?us-ascii?Q?OV5OmXp/HcmR2ghyHjZeNvaUglCvTjPZJtzZmdKy0TmuxNFLi1jLbBTvqXZk?=
 =?us-ascii?Q?ni9H9h5AqZB4d6cEiX71VkKJXpM6mY3//eZf/vXo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d701a65e-79c2-4e86-27ba-08db6e6267f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 12:08:33.2405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SH9WcQ+ld7+RZ3iN+7wKbwZLrKHd6iiWVXw2abZzmjVpk4w87+Z3qeFbPUbtWuLnmMSK4W43rmqVnwOb+WEEgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5798
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, June 15, 2023 10:56 PM, Sean Christopherson wrote:
> Because that's even further away from the truth when accounting for the f=
act
> that the flag controls behavior when handling are *guest* faults.  The

What do you mean by guest faults here?
I think more precisely, it's host page fault triggered by guest access (thr=
ough host
GUP though), isn't it? When the flag is set, we want to have this fault to =
be
handled by userspace?

> memslot flag doesn't cause KVM to exit on every guest fault.  And
> USERSPACE_FAULT is far too vague; KVM constantly faults in userspace
> mappings, the flag needs to communicate that KVM *won't* do that for gues=
t
> accesses.

I was trying to meant USERSPACE_FAULT_HANDLING.

>=20
> Something like KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS?  Ridiculously

Yeah, it's kind of verbose. Was your intension for "NO_USERFAULT" to mean
bypassing the userfaultfd mechanism?
