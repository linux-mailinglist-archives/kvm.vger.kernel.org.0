Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58775EC5F8
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 16:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiI0O1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 10:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiI0O1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 10:27:07 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CBE78BE0;
        Tue, 27 Sep 2022 07:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664288826; x=1695824826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ag3Tjw49gNZSWNugG5+sIPxd5/txzE6eJoEkE4QLnhI=;
  b=eYkvzDGTktFiYYKAOU7gYu8kdvoLjGEnjVLAdnWIx7hhBT8868Sj8/+u
   SkLfeFw9JPoNuSmimeJlt+9AL1CmyZqd5cTRddYKE2UGUST/9qquuHTO6
   tUbCD/0y7oCvEtnf57i1jAFvB7SGtk5Qom/Rm81E3JIEx9vTtSd27uaYv
   n+TckK7mjjnK9FvvxO1dsdLpqZ+bNsWz6b5gaZCrlBgddiNdPHBZ8+PzJ
   vqo8uvm0HgbXyTnMf4OENBd9r9HRsjyUZgRl4VsfqXlNIU2IVkuhFPB79
   ZLAm4W3+jzPn4KNSSomQ3wGEx++jTi+SwsqRbMLITW4F7oLbsrFdiPmef
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="327686373"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="327686373"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 07:27:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="616845718"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="616845718"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 27 Sep 2022 07:27:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 07:27:03 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 07:27:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 27 Sep 2022 07:27:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 27 Sep 2022 07:27:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+aVjhxz7fC0Kd0d07b6MXS7VlWGerfOWp2K3UaGU1Cj20DmxL2G2Lrce3w6ejagD+0/uy+kXIA9h4TdYPvlt1UcKXmHRFlEOh6DpAMuJU567gj4rWyG0M/aLFqfTwPI7bMWMg5aTkfdV17if68HRUvMy8Ldrg10g5oLQUwpq7oUoZbP9HY1MUdfheROAOOn+1q+p8y7IQgJ0svVztunB2vDsLE7ytSF4wWw0RZUTq+YFldW0OMCSiJXOi6i/NSNAX/WJYzhqKSQLmqwjsuK9AJ3Hteuy1mByk6PjDa4FGkJg54y3gJGDXStfkJ3ZrIHv8suyBGDxIxGBIVSeeJ16A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ag3Tjw49gNZSWNugG5+sIPxd5/txzE6eJoEkE4QLnhI=;
 b=icFUE7Yr9LGIH7bqQT2oZI5iSEmLDgeH6VSfu/aYexd51xtAKArll+Igjk/5JhNagcXLdOfVgZ6KFN5w4dqExQdRbAGweVsUyvgo40b67eM6H93PhS6UFwOx4BQSQAjFV6LBYOaYSKn8s0InpqSNiAh+TJjLYBlC8kiRF5fySbKpT9xeARNwnbeXlc5XSaVsSrL/F2JiYZ+U9+tWesBeEPoQCrkCfm4VpzXDwJj+dI+it//UAff9oFjBq1qx/tum2KMgyfrIRxv9GMpsGc+//N6XZZY2XpkymA36Ury9JHqOlfX+zbh4Kn2bLWMzR7N3hf9HlTfIkTctfeLi0Y8Rmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MW4PR11MB6787.namprd11.prod.outlook.com (2603:10b6:303:209::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.25; Tue, 27 Sep 2022 14:27:00 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0%9]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 14:27:00 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Thread-Topic: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Thread-Index: AQHYzdmZiDfxfKVenUORyjhoUz2tZ63rY3WAgAAA7VCAABAZgIAAAWLQgAAITwCAAAOJIIAGYXgAgAAaq4CAAAyEgIAA8aCA
Date:   Tue, 27 Sep 2022 14:27:00 +0000
Message-ID: <DS0PR11MB63730CE4DAE000E338F092A0DC559@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net>
 <DS0PR11MB637346E9F224C5330CDEF3BFDC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <YyxsnAFYMLn2U9BT@hirez.programming.kicks-ass.net>
 <DS0PR11MB63730A85E00683AB7F6F3E26DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <62d4bec1-a0c3-3b01-61bb-f284eede6378@linux.intel.com>
 <CALMp9eTG7EbRv_fnQpDMQ3YUjYANgu=6QwVj_ACgHnK-Mhk39Q@mail.gmail.com>
 <e1327377-8e82-56a2-25e5-2ba91f2eec42@linux.intel.com>
In-Reply-To: <e1327377-8e82-56a2-25e5-2ba91f2eec42@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MW4PR11MB6787:EE_
x-ms-office365-filtering-correlation-id: 2a24bf58-64b7-4d92-70c0-08daa094571c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 95aJBEXoBDiptzwjJO17Y9NrQhTxTSoKIEz8qWXrV8Nbyum/Zqgqgj8W4cYZzMC52LHtNG54CH83LJsdhl4RkTGHGnV0V/YHf3x5BbT88qwlmSZhVVXnBjRQ+L4PptC30u8u6MOBCUcfi4+yowZ36UunXhQWbOS676LyOSXgkeI9bk7bN90gCtef7IkQ5SdSkiO4HDfioXmlyTE5014zwkuHuQvycfJMsDZ6pOku/wtIF1n25fhUQHRDr5gbdUDbBxn5F3QT093PoK0fQvj8n+PNYZ949mwfOjPo6HmjYynU/fv9++OuVu3HEObfm2v7flgVe//C1uZ3ZOei9HppAVkKKH7yMdmuw53IAGKmaamfmDnIpr3K4LR4CjKxCjlSK+D2fELFLdk1dPft3NtBWlRKcxjzAjBFOXIuqFGpj0BSBE5JyF/OTc4+Hs41hqlEc4CVG/Em8sN3OL7xG0s2saINTNRwmvIP85rLA3lZ/oAcRBw9LTYPFsTrb6NU1GND6dGAk/fWpIG4NPR0REuNcjgbTxQY1Q0p6wIn58R+vXLMRx9NoFvkxzwJvOUwHFGujuK0/aJfQF+c4wHEaFg2iKy7dVftvUVrhcCjt5IIUMXKm75toy7ipY0IyJ+8DV+49bYTkmqpdspRkI9MSr0wqreCqoAPVHjCJGb/CloeRsygPCBcHV//jF9jgMuQCzJFXHYxw2chvOLJkM8EzJskY0m3DLHyackJwgFWKrS4iAwq/hTM29IeVEeot4ei3tqfmPkpq0zIwt+xUGN14zWgNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199015)(9686003)(7416002)(26005)(5660300002)(41300700001)(4744005)(53546011)(8936002)(2906002)(33656002)(38070700005)(66946007)(64756008)(66446008)(66476007)(66556008)(4326008)(7696005)(52536014)(6506007)(76116006)(8676002)(122000001)(38100700002)(71200400001)(86362001)(55016003)(186003)(82960400001)(54906003)(110136005)(316002)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?55aGMvwiTz001IfGoivZR4Yd2Kv5BnnmEtd9OkfGc0o4Vzd/BrqX/Dvf0Qj4?=
 =?us-ascii?Q?NO09dwNbYIZXjF5N+yq4Dw+KhwOlB9O3S3ucxfvsqNlTP0xeFcSeOZ5UzLCy?=
 =?us-ascii?Q?vp72FyvPrFJBgTJ0Wa5hWG1/chnN+jSSz5qNxL2+2ZltT2KoLrlCzAljiKnu?=
 =?us-ascii?Q?2WpqGmTjK3pi00ny2iBbQKfTDjvlKYrVRUr6Cegp2SnHhr6gPvSqTJV4L+TI?=
 =?us-ascii?Q?0tZgDE10PL/pFj96kmObRSby055jKN1uxt8iu9XZlfGw95yGq8E6mUjpnKCJ?=
 =?us-ascii?Q?bakhKWITcE3sJJN9dkkhTDsnFxylbbZsi8VunAoKuUrLP663CN8aMTlvatW6?=
 =?us-ascii?Q?Ekoh0m/XgXkCkNXIiauSIQGH8ecA9pZwvmP3pkhQRNZoihJfsbEhyraDEmvD?=
 =?us-ascii?Q?yrCAT7UPapsUMSWwWWsHNXhjCJReeRDGpX2uWdIEdKW0zfVqOXX+r1jcr+tw?=
 =?us-ascii?Q?GqYNtoUarR4rnqXTc2xkvUerelvlPwvmVCzM6Qf7BnE6OInkcMwrvpLelqBc?=
 =?us-ascii?Q?iaqUqN1QwNvsnGVNHSAJ7I1U2zPIdrxxccCAv8qe8Hi66rYGcwFUzI302Zuj?=
 =?us-ascii?Q?OP+1F6aRG0HhVjLm3NrF8yFAUxMZIcW798J7jkl9mfMA/yxZhPqGvMnoZ2Yk?=
 =?us-ascii?Q?G9DRMir7LGneLTQ4PwpFit7nG2SnJ/Qud2y33L5xGC3IXkdGm48aTStrtQPb?=
 =?us-ascii?Q?J5uFeB2NRw7d+DWS6w2Db6TLg5/326f5UJwpkiCPCcFvWEm+SrHYcJTvYJ8g?=
 =?us-ascii?Q?ryxTwFgwBaxfby08XlEo7+a7PRCtSlx3x8gZqS5sZp63Qhb33cgHpPPFhclA?=
 =?us-ascii?Q?IBSc3FNVxZGn97se7OnL5oZtL0Ss6UJifdkItN6RyCpJLT0kDSohqNtVxl5F?=
 =?us-ascii?Q?ai9pTwsI5Ut3bYaxNIi/+p/9/UggV4bv3k6izwmBGW/cl9CvP8rume5WGEaS?=
 =?us-ascii?Q?W0XWKnXt4wK5sZtBnfASVYZzUrlfn5A12Fqn8tchLiFkilRcy9y8GV7mLmm8?=
 =?us-ascii?Q?IHv7amSiP+O75kTRsCzuxd/1PbwS8jxhKD6H6oY/4GVkAaGuTOKOp+/o2or5?=
 =?us-ascii?Q?MqFXjDSHXmnRqNtKkuFl7c1RiUx+Yfnkz7PDoswtK3dLZCJfEuga0JaR2MSp?=
 =?us-ascii?Q?WLRnQoEBUmqGVIUJleRWQduFRlcxMeb545MTuTnIRGJxdqWRQAZybZHlSptU?=
 =?us-ascii?Q?SSIKa54bfOAb7BJYwVG69+sVbWuukG4I1ZyOcXLXcegpXsWHkhlWtaR9AQUQ?=
 =?us-ascii?Q?V9Y0NeMbZ1TukUvwQDom8qrVtc9dLdaZlqjI2AsSHaCao5XyIJdQhDeax8Mo?=
 =?us-ascii?Q?hMAlPTNZvlrK/4lDInOyn2/DhxNvyVUTH+IOxpO8iLAcMwGSOlWyKeIfyY+2?=
 =?us-ascii?Q?EKYjGMcywf2rP2VyU9sL5GMTV6/1lNVVyXbB1SWLmwQksgSeDhar+h9O3ueY?=
 =?us-ascii?Q?5deno87vdrM/lD2uzFtR1yC1Wp+TbKYYnPZ/HGn0w+SYzr31ew2bLgHCBun2?=
 =?us-ascii?Q?EHnwSSevtThhe+0TY+7JJ+4h3hsu36E5+ZCEop+9MI9yBpKYZ69PSaw/Z6q4?=
 =?us-ascii?Q?ouvmPMtPoIjuccY48ZeLb8Pq1DpdHc7RlsuGabln?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a24bf58-64b7-4d92-70c0-08daa094571c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 14:27:00.2794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WBkW2pDDTGBEilJ6V2KbcGoBBwtBb2ngoogXz0klzD0+RRz7hyAIHIFodCu5QJCM4VdWZPlEFmX2E6YptWmXnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6787
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, September 27, 2022 2:09 AM, Liang, Kan wrote:
> From my understanding of the host-guest mode, the host PT event never
> traces the guest no matter whether the guest enables PT. So when VM-entry=
,
> there is only a guest PT event or no event. If so, I think the perf tool =
should
> warn the user if they try to create a host event with !exclude_guest, sin=
ce the
> host event never traces a guest.

Probably not from the perf side. It's actually an issue of the KVM's pt_mod=
e:
How can KVM prevent host from profiling the guest when in host-guest mode?
Just a warning from the perf side wouldn't be enough. I think that's a wron=
g
assumption from KVM side. I had a plan to fix this one. Exposing the host e=
vent
can tell KVM if the host is profiling the guest or not (i.e. host-guest is =
allowed).
