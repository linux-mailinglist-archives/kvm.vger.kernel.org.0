Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8F36BDB15
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 22:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjCPVme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 17:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCPVmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 17:42:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0688488898;
        Thu, 16 Mar 2023 14:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679002950; x=1710538950;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v/j9iWsKdnI5AvhP7u7HHL+eHPrnyUUvyLB7MSLSQ5c=;
  b=Cd9E0oKL0ufqaiqGBtHRpDlCI3uaIDVVBeP6sbqq7HzFrsIYO6UHWTPd
   soOd4OSWvI/sIn+aRwctTnwWn0gfOVuBtDOvnt03QvMX3ClMyx33RA6Tp
   z561qYdaFsSBKBpSf63ge3LMSBsgnI3OwzHvIldhcqvEiP5L/lQgqyQ4O
   CS62/8TedtzUQG1CPt6CQrqMhQfJjHLvR9sqDtMg3sS3O8LAt6iu1e1IG
   hZ8wGxMXWLHMngXJmsmIGpzNOtoFL/hip+NeeM+cxtVyC0EiH5FhgBATo
   FLf/RAdE7AJImo1ppaGVn/5sF8exMvh7XRjownsWRIdFPEb9ay8fC+k+m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="424389624"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="424389624"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 14:42:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="790476893"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="790476893"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 14:42:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 14:42:28 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 14:42:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 14:42:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 14:42:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7rKP8GBszHEZTwXUoY19kl2dAz1KkekPxIP9JEAGGE9SducXNpVWoWWAvi4UzGTD7xe18Bo1CjWOLoXUvqjMKQcwVvm7K8KC1y292Th6l8pluQq/nsAXuGkmykPAlC7unixx6fcps0UB7UzMTcI1na3evk0lBydpNGM65ETe9kpEk1zNadtpfk3Oxn9ZRqGbBRnw8E3iQuXxrnjaPKZ0kQbrFAdSU7jgxqDch+r1Y4HwVHhLXZtP613NYGjcvEXKe4msS/sKu0fpvnMJosUv/R42HHNAETUYShDfV+AJnl6UhxKKR+3CNUmxPUsEqEob3e7mrF4+BdaXlReZplkaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/j9iWsKdnI5AvhP7u7HHL+eHPrnyUUvyLB7MSLSQ5c=;
 b=mAcjUB76ems2UpVIdJgmIN+IkIR7rzHZKGiwp7EvgMfzvaiVrX7GV7/diTXtoXnmaZmaW3N4+7geb1S2HAKAvh1u8/H3cqtp6Cb3Sm/LfZuvWsy4BpNyFBV0xjYjrA1oTm+duri8PFKqfa1YgLYKMEIMCOyF7Q5DEs0huqADm1tJhsBdeKLfoMohYlBibN9OXoMuaskwPSvNOb6K0mIMwIeK6kt3BVn3KcJLwxCYS8HXP30r2ODWVFg6Ho5zrKLUFVqHz594qE5/nnjBlF7k/VrcU72i55iwCsMysGi7ia19Gh+8Aa+9d44WhCdogNs6doGxRgxofxw70QU7qNfztw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4597.namprd11.prod.outlook.com (2603:10b6:208:268::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 21:42:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 21:42:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 005/113] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Thread-Topic: [PATCH v13 005/113] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Thread-Index: AQHZVQwsEyN8OR+uzUGmoOAGwNdYLK77q3uAgAHl7ACAAGTegA==
Date:   Thu, 16 Mar 2023 21:42:22 +0000
Message-ID: <9e7a89975e3aa69114a7e3325fd8e54d633749b1.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <0545bd8a7b851d5b53cea16e7e4624b58dd9b71e.1678643052.git.isaku.yamahata@intel.com>
         <70caa84177d8d4c3ace65663992ba4d72f939f4e.camel@intel.com>
         <20230316154118.GC259042@ls.amr.corp.intel.com>
In-Reply-To: <20230316154118.GC259042@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4597:EE_
x-ms-office365-filtering-correlation-id: 8b234253-f233-46e7-7422-08db26675398
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uZTcS/QPQ/83i9JePommuDOI+0iWTSkk2aERgyvqKJoLC6Ksg/Q2PGKEAQZnyhZPhG2Gliet7jFQMWvsCA4m/8yXxYsbaR7wYbaU/vpH/TIk/yE653ER8jM3SJOpHgOc3NVmOOvNoQ29dOyN8TjwDLmiowRYM8jQ3/FoBQZjKGPVayWSPa/bIMgCGd9lvPHJx7SEb9cywUJ8fOA3p05z8Ztk38sUd7S3Oa6J0I31h5iACZYQ1p7vMymfxnia4dTX1NbvRY4sZG6JiAW+mRGH2GDIF5f7ygXYJEyYNyQoucgdxLu9oPBwNgviDP5NuKE5PjRuSzS2ONi0lqrhOQrl3MmqnVJt33t+SWVZyE2ucyaG1qa8ra1P7isrfx/JlxAtzzcvB4pS52xtijcleg6CsKmMdBd3VULMyUcYgWMayEK9b6OzHPB0Z8II+eSZik0NlqGhhawbGhHy4Lylsp3/KQzfnGnhK7NA6bGO2e81GX1WVCrlXuWHLlsjAcAMd0E1ljhJaxQ+DgaRGMIIkpfxn7noy/CHegP/z56QRVDR17I9CCthx82ZbIH1DZVVo3e4uB2BNGSOvBcNW72QcdUu9lOLPE+D51Eo1sCxpj+HqqLHQnOPgvRWLvBJJtPQTEBXCGeRzXep9F28BFsLjlSfW+sqbOvCmuCmsyzl8TfXfPGFDWZnEtiH9/aFMnqciLYTjJpoengovKbqpbECN0JLlA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199018)(38100700002)(122000001)(82960400001)(2906002)(86362001)(2616005)(316002)(71200400001)(478600001)(107886003)(6512007)(54906003)(38070700005)(36756003)(91956017)(4326008)(6916009)(41300700001)(64756008)(6506007)(66476007)(76116006)(66556008)(66946007)(66446008)(8676002)(186003)(26005)(6486002)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmJoUlcwRXhlUnBualFEOWhKZkJySHRjUlRTTW9SRFROOS9SWldBNUZTb09G?=
 =?utf-8?B?WjJ4bkxZZ3RqaW05YVRPMlN2TW9GeXlZNUNycmxaSURaQjBLUWwzSFhlL3VS?=
 =?utf-8?B?bzVwaVRiTEdTK1A1TDZIVTNocGNaaFRFSVNobHFZNFdzMitpNHNXZ0hUWmZC?=
 =?utf-8?B?Y3FqV05SSTlxWmdGVnVTMWxiZktsR2xUYzJmQVVUWEhBMzJBZUc1eE0va2xP?=
 =?utf-8?B?QWE4dkxIU2VBNWZMMG5RQmw3OCs2aEduTTV6WnMxQTdEc2ZhRjZhUjYvNU56?=
 =?utf-8?B?bThCbjhuSisrOGxaelNEWUM3VkxPS3F5YjhPclp0N09XcEFVSWUvTlB4YXRG?=
 =?utf-8?B?RUhsTTF6N0ExUEp1M01IRzY2NUtZcEo1SVhkUFRpSE5kclB4MkwzTG1ObzF3?=
 =?utf-8?B?U0hGRWlXdVdnQW9mVkluT1Q3OGc1VVp6VG1MSXpMSzVnWFJkREJzRDdLZXY2?=
 =?utf-8?B?RkNzaC84TE1sWUhOVGNMd2ZBKzdrVlBPTE5wWm9QUXBQZC9EVEg3VXo5UEFp?=
 =?utf-8?B?Q1ZRSWtkeXlDK3NoeEkrTldsanZSSTZJMmFhREZHYzVGY0pBVnJYMmN4bTl2?=
 =?utf-8?B?Q3d0K0tuRENRbi8xNmZPbUR6UHBqdTdmSHl6SHk1MzZkU0FreFBORDdQL1lx?=
 =?utf-8?B?OHo5a0xCSlh0d1BtZE9NcU82RlZGMzk0RVE2RVVYOWNxS1NFbHAwR1NYbzZB?=
 =?utf-8?B?V2k4bkNGQlp4SFNRUjlPMkdTSGM2UVBKQzBXOTVjQzVKeXR3R2h4N1RwanRG?=
 =?utf-8?B?eVZ5VGdyUW9sT2RlUGZNV2FkMXhOUndJZmtnUytJNGErdzRqbGpCbFdNVFFj?=
 =?utf-8?B?TjNRMmRpUG10d3hhYWYySXhJSUZBTWMzaXFKTDZoazlHWmlzWXcxLzE5V3Ax?=
 =?utf-8?B?eDcrKzVBNWxXU1hhREVobjhZWWhobUY2QlRNSUVDMlNqbUlCYWpFOUZQV0JX?=
 =?utf-8?B?bXpUemhEeVdqRHRKcWV4N0pPdzNobjA2Um5ZcmV6amNvR0ZMcWIyU0NzbkxE?=
 =?utf-8?B?WC90cmVWNm9udHFMbWJreXNQeDIxVWZhdjRuU2RSelhDWTVucGpLNXNSUm5I?=
 =?utf-8?B?b1RlQ3ZBSis2TWZsU1NtcU1EWFQvZUdvSnZac2szaTVTSzV4Y2c0eHhReVh2?=
 =?utf-8?B?WVRHMXA2SlJscU5XZlR3Y1hHSXdOdGZpVmxldStHbWZIWWJXMmlPanFlU3VW?=
 =?utf-8?B?d2d2OE8yUGYzbnhSSG85RTdreDROZmdTVmUrWDJZTnptVGdNZWlzYWs3Y0Nm?=
 =?utf-8?B?WnNxRWFvWGJnaUhzU3Z1NThtd0M4UnRFVm16TnMvb3hwTjh3d2NMMEZUUEhX?=
 =?utf-8?B?V3A3dStzTTRNUUFxS1R4MzJ4OWtYLzZCcGt2N1NXZDhXdjljWXJIRU4wQis5?=
 =?utf-8?B?QmxJL3ZmN1RXdm9ER0xCZDA1VHpsQlowcjdMdnYvWmxVOUxzK2d1b0U2cklL?=
 =?utf-8?B?T3RQNEluL0pnVjNzTkFoVnE5SDROd0lscFRaT1JTWlpOc0I1cXU2NW0zUXE3?=
 =?utf-8?B?NEhjeFhLZGxNZEl1Ynpnb2FUMGRXWTNDMmFNcHdKbDNGWG11WHNtQWpXeC9k?=
 =?utf-8?B?MWRQK0N1Tll3UDJZNzBVaXRsSUNzNG9kQUcyWDczbnBldFRPVnVxSVN2ajdy?=
 =?utf-8?B?WkZEOGJvVzNkcHluMGQxNGFMeU5ZYmtTRUdQK3gvNEE2dElBOExPUlRoYlds?=
 =?utf-8?B?dEJRallhOXpWNmY0eTdZZ2N0ZVhZV29vTlBNNzBXQVBhanloOW55Uk1DZXhL?=
 =?utf-8?B?QnZSOENxQ29HR3pxV1Z6bEMrcC9KRFZ6SUpKR2RlcmxzSU1Sb1FKUkJrZFFL?=
 =?utf-8?B?U3Jwc2Z3Q2Q3QisyUXZkcVNrWXduQU1zdXh1NytUOWJaSXhXVVhick5ITC9Z?=
 =?utf-8?B?aVRMM1VmY2gvdHJ4UzJRTzVtU0N5b0d1QVRzSXVPa0FhNFlzSS90bGFhRW4v?=
 =?utf-8?B?dDNhb1lPL3U1UTM1QnJBM2VkNnRJSDloVFJpMHdVVkFsUlJPd3J0ak04b0RZ?=
 =?utf-8?B?R25iKzByQ0RaY1gxNDdHQjdnbXVtbEpBZEhENHZ2VXE4MUI3bWlDRlpUZmk4?=
 =?utf-8?B?TkliUk40bzc0UlMxbEUzdWJjSmg0Z0syMTU2aVdVMkgraVRtbTdqS21PUFBn?=
 =?utf-8?B?dDVoRWpaYllrTnBBQy9sNDR1TnEvdVYyRkxXYnJNbDZtRlBFbERpd1VPRE4w?=
 =?utf-8?B?a1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F23A78107441143824B1D8C99E5AD2E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b234253-f233-46e7-7422-08db26675398
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 21:42:22.8419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpEErl4E/P2IqRbKyp6ImeUof5pNjg4JJdtvEnPw8u/a7IVWoYLvEiLvSfVw3FnVebGgvtxpxTuC6oqRzAebKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4597
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTE2IGF0IDA4OjQxIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gV2VkLCBNYXIgMTUsIDIwMjMgYXQgMTA6NDI6MDlBTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gU3VuLCAyMDIzLTAz
LTEyIGF0IDEwOjU1IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5jb20gd3JvdGU6DQo+ID4g
PiArDQo+ID4gPiArc3RhdGljIGlubGluZSBib29sIGlzX3RkKHN0cnVjdCBrdm0gKmt2bSkNCj4g
PiA+ICt7DQo+ID4gPiArCXJldHVybiBrdm0tPmFyY2gudm1fdHlwZSA9PSBLVk1fWDg2X1BST1RF
Q1RFRF9WTTsNCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gDQo+ID4gS1ZNX1g4Nl9QUk9URUNURURf
Vk0gaXMgZGVmaW5lZCBpbiB0aGUgbmV4dCBwYXRjaCwgd2hpY2ggbWVhbnMgdGhpcyBwYXRjaCBj
YW5ub3QNCj4gPiBjb21waWxlLg0KDQpPaCBJIHNlZSB5b3VyIHBhdGNoIG9ubHkgYWRkZWQgdGhp
cyB0eXBlIHRvIHRvb2xzLy4uLi9hc20va3ZtLmgNCg0KLS0tIGEvdG9vbHMvYXJjaC94ODYvaW5j
bHVkZS91YXBpL2FzbS9rdm0uaA0KKysrIGIvdG9vbHMvYXJjaC94ODYvaW5jbHVkZS91YXBpL2Fz
bS9rdm0uaA0KQEAgLTU1OSw0ICs1NTksNyBAQCBzdHJ1Y3Qga3ZtX3BtdV9ldmVudF9maWx0ZXIg
ew0KICNkZWZpbmUgS1ZNX1ZDUFVfVFNDX0NUUkwgMCAvKiBjb250cm9sIGdyb3VwIGZvciB0aGUg
dGltZXN0YW1wIGNvdW50ZXIgKFRTQykgKi8NCiAjZGVmaW5lICAgS1ZNX1ZDUFVfVFNDX09GRlNF
VCAwIC8qIGF0dHJpYnV0ZSBmb3IgdGhlIFRTQyBvZmZzZXQgKi8NCiANCisjZGVmaW5lIEtWTV9Y
ODZfREVGQVVMVF9WTQkwDQorI2RlZmluZSBLVk1fWDg2X1BST1RFQ1RFRF9WTQkxDQorDQoNClNv
IHRoaXMgb25lIGhhcyBhbHJlYWR5IGJlZW4gaW4gVVBNIHNlcmllcy4NCg0KQnV0IEkgdGhvdWdo
dCBTZWFuIGhhZCBhIGNvbW1lbnQgc2F5aW5nIHdlIHNob3VsZCBub3QgYWRkIHN1Y2ggZGVmaW5p
dGlvbiB0bw0KaGVhZGVyIGZpbGUgdW5kZXIgdG9vbHMvOg0KDQpFdmVuIGl0IG5lZWRzIHRvIGJl
IGFkZGVkLCBpdCBzaG91bGQgYmUgaW4gdGhlIHJlbGV2YW50IHBhdGNoIGluIFVQTSBzZXJpZXMs
IGJ1dA0Kbm90IGhlcmUuDQoNCj4gPiANCj4gPiBBbHNvLCB3aHkgS1ZNX1g4Nl9QUk9URUNURURf
Vk0gPT0gVERYIFZNPw0KPiANCj4gVGhpcyBwYXJ0IG5lZWRzIHRvIGJlIHJlc29sdmVkLg0KPiBV
c2UgS1ZNX1g4Nl9QUk9URUNURURfVk0gYXMgVERYIFZNIG9yIG5ldyB0eXBlIEtWTV9YODZfVERY
X1ZNIG9yIG90aGVyIHdheQ0KPiB0byBzcGVjaWZ5IFZNIHR5cGUuDQo+IEdpdmVuIHBLVk0gaXMg
Y29taW5nLCBkZWRpY2F0ZWQgVk0gdHlwZSBzZWVtcyBiZXR0ZXIuICBJJ2xsIHN3aXRjaCBpdCB0
bw0KPiBLVk1fWDg2X1REWF9WTSBuZXh0IHJlc3Bpbi4NCj4gLS0gDQo+IElzYWt1IFlhbWFoYXRh
IDxpc2FrdS55YW1haGF0YUBnbWFpbC5jb20+DQoNCkknbGwgbGVhdmUgdG8gU2VhbiBhbmQgUGFv
bG8uDQo=
