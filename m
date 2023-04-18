Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1A76E574A
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 04:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjDRCII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 22:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRCIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 22:08:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88881A1;
        Mon, 17 Apr 2023 19:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681783683; x=1713319683;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=9tC3tsuuRtXoeIax7N6sEHoA4pKlCG6ju13rnbMyXnA=;
  b=aBYPylfP3fEHLjzkpA7HKpYTxPqlBDX9HwdDl/IK22mQDUnzELM9mSa9
   lfbvMQqNWMoHVxJy/AnVC0j/rzXADGGw89yfw8kfM11CrsH/zl0wkxs/A
   d6Phyh6NkbSbej4h/18a1sR0Gr8wQvfH2YNfMGDrwcUuwU/4YgpIIqph9
   P0NTK1cIGLlA6JF2hXELGyOJXqkEULqzJm777szTxwhLNNfLo+K1jmJSC
   C/fOre6CrH63qfkKv8hFU8ZnAVZ63UnDLY/6QsI9TXzFML4nKCQeyFWb9
   FItU8wLBUrazHaEaLmHAsyVZT1Gpx1eCs7s3A+n4Atr/lHePV/eaBceXk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="347801815"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="347801815"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 19:08:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="834682362"
X-IronPort-AV: E=Sophos;i="5.99,205,1677571200"; 
   d="scan'208";a="834682362"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 17 Apr 2023 19:08:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 19:08:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 17 Apr 2023 19:08:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 17 Apr 2023 19:08:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 17 Apr 2023 19:08:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZIKtWxjToumUKJgr2inAr2uVtut2vrQHAo5Sdg8wWb4ERznB7mAL7bt9oVGVORXVbSE6FhEgCiuz7cTi2s8U9X4S8liioO/dx5n8IoBV+8xPm4mE1NEoCocLCly3EU/OsyzxWIFYZms04kkI67UHwUJ9UKiCyFlK2ItRpqGIFb5VSMhAnyHg0KE08F+VDgu+Bn62MswQY1p4oTTgSr+hh9IHdQz0AQHq/2Us6VoB/fZEgn3U3Nf/gwwZq5WGn0+sxxjFmAKi95CI00eT/01Zp4bT2rFbyaXBwLg2GHVC2T8nuKVTSQdOv5wDpDj/3C3IA4HPu49on8OQiEoLzCWrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ji4sCF/s4qRMfm8tpNPBeNdOFBRa/bq2JRZjMfLFexw=;
 b=oTNcIs3uaAZ42Ea4KITVejkwajfvl0M+SUOkGFr5a+EanbimotKv10r6fsh5MLwSGh+ALssYde/dSx1KKwohL3gBdSMhSZ1F87gaJaKWJMbuLIm/NuOb/ZQuVdOyMZO+luyzRltw02fufWFxD65aOhvXH+kVD20tQKQmZuGJui4N3suowny6N47DBLw96+AQjhp4Usf5+fINHDPagMwnMolX5seYZR2m4VfQu+d35C9yyjw0cpEtBRuZQpLM/nqV9pNvTz+onpvsvFxVxRXKqVkueJrbXx/6LRIJQJKsIGGuu315JHJN1yOOJZTYAcOc4RD2T2ELEIawSVsJAJVf4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SJ0PR11MB6576.namprd11.prod.outlook.com (2603:10b6:a03:478::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 02:07:59 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 02:07:59 +0000
Date:   Tue, 18 Apr 2023 10:07:47 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, Jiaan Lu <jiaan.lu@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 04/11] KVM: VMX: Add IA32_SPEC_CTRL virtualization
 support
Message-ID: <ZD37c+/9l/nbvPnr@chao-env>
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-5-chao.gao@intel.com>
 <35b92d89-3eb1-368e-3804-e3ce9ad9c81f@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35b92d89-3eb1-368e-3804-e3ce9ad9c81f@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0186.apcprd04.prod.outlook.com
 (2603:1096:4:14::24) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SJ0PR11MB6576:EE_
X-MS-Office365-Filtering-Correlation-Id: d77073dc-59f3-47df-ddc6-08db3fb1bba1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dIkLX0cqM34mxcB7DbuMDXeanF2cHKg78MfJPkS5DFBBjKq6ogw/VnEH8FBGhwVPSt6UvxNydlhwG69bMB4mmL5pMALWAIhhZ8hNICy+iGkBgYiC/wzPNDCQYf+kdr+w2YFoQ8xPr0tc9WTxbb5QGFxbUNQXE0maPEFSamYe5bXxV0TP3dE6z/ZlWOY+INp/AduDv7oWgjCH8LhTn770q+pSGWvuhgP8kKxL8yUM3iMh3h1vQOieIazjzbbff4Fs9S+omk0g1eE14lhFtMR+8y9hZd7bp0IoU6UutOPL5xFHM004Uvojhz0WZr1eTh2AnkixicNNJdlEnCKu0v6m/Z1IhIopGQtxAtIWaQ+pEFmKsuJiHXIoIAavDvcj963sP9wrNuisvNR41vf0wbaaDg2RHvFghspoC+tJ4ZsfvX/8TMpj4HMnH73xzzcIsDwfFa3Y0vWPm9B97vbF5OMm2llWdJLMM58ryYxW2fs4JEONuXobrKtNpOszmVvQCTEV75HBEFY3NoiEmn7W201d+S0N1UjrH1SihGr5uYa1vO55JBeVlJzmWzznCBfPLbKw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(5660300002)(6486002)(6916009)(66556008)(66476007)(2906002)(66946007)(4326008)(33716001)(44832011)(7416002)(86362001)(8936002)(41300700001)(6666004)(38100700002)(478600001)(316002)(8676002)(82960400001)(54906003)(9686003)(6512007)(26005)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?lurxUCTiFXR2VkEwW2ExxkJV7l+vAdw7yevDCeFglGxHm+SZ1NGDefu6EQ?=
 =?iso-8859-1?Q?rTapwuG0Ygxa24PxmnqvV1nvEc4BSItLg/A1FQP939H47tX4+QIxNa2R9Z?=
 =?iso-8859-1?Q?GJelfT65ecTJlrMbqgGrhm+mflbkTOFOU6dHy0A5xjZtt5hVqtXH3QhNvg?=
 =?iso-8859-1?Q?bSqAHD+mRjEdDbI/mHmlgDr0L6YySFXEtdn/docCxnjoqSMVgpeiOtNefc?=
 =?iso-8859-1?Q?wcuRRS2UgJfKr7Tyv2xtXPpLqYDTSdvP1pw5NVj+ttiV1KtDCggJ/t/+Yk?=
 =?iso-8859-1?Q?aY1Sn+WihVuc2Ki8kuiFhK0FsESoKDwIddXUMBVVjxc7kIdy7qbnGAcSzR?=
 =?iso-8859-1?Q?KJw7rQ/8cvh4ejRQSK5FYj+hi14YxW4UxfhtarNPzWRFvmF/5AZ2QEhiBu?=
 =?iso-8859-1?Q?3XrrrmgNA/B/aqiIAY8yzRpbRPBLemiPn9AU24TeIO6EWQ3wDPt8vo+i5w?=
 =?iso-8859-1?Q?02aV5CHh50f2sFKk2xyx9LrZzjH0QMNaXM9yXvXivjOUp5h6Ylqr1W1omi?=
 =?iso-8859-1?Q?uaPRIzrUoFG/63UWJchFC643doFB9RIsV7NkgaZVbnw1n8Rj4zmDHFM+5y?=
 =?iso-8859-1?Q?P1um8ne6lB0zISYWfO+8Y793YQqEx7FE9DsLJhD0ZqkI3wHw567EZx9fhM?=
 =?iso-8859-1?Q?XYlj/4nRD8ZKfebiD/W2h9KcKTWwx4rIEBWsgSHwtOHuC1K6mWnK05hraL?=
 =?iso-8859-1?Q?1gHL1a+WIIB73eCo/HPIRiMJzs2j58zQBaCMdnHjS429areYYiXsLdWhuq?=
 =?iso-8859-1?Q?lbborZMxzmL2pdZiFFm1sJ2c0vyc3yEqdIjvMPafjxzXpWDMFMqRt1t3Dc?=
 =?iso-8859-1?Q?QszK4bnTyzoPJ46obuZxhd8lgO/gS5MrFMlBVnTlrOub5pA2HfygXXUw53?=
 =?iso-8859-1?Q?slxU02syNlwdx4eKygHbwElxRXpNkk8WHTcIEflE7mU1iprLZ1SZhIiWdB?=
 =?iso-8859-1?Q?6JXVFC6OeXUz/IWlonDoz0zo0oNoMa3WYSEk8VHsI8GpNSpN8B0h0sbl/B?=
 =?iso-8859-1?Q?0e4ZlX+vf0b3H6AmDaQDwPonLYjqnfJkfLxiL3foKX/t18o3Y/0h5+e7mR?=
 =?iso-8859-1?Q?Fg3SEeagxmzbHShdV8g66UMLnDc4vZl5wkYoNQ7+98Mv7ZCe/bc2/VKMV4?=
 =?iso-8859-1?Q?4sAgmNrP5jurNnRxkfcdTWJGMgz4Uta2FnUAknFG1+5T8KoQrGL3rl6dFI?=
 =?iso-8859-1?Q?5tXFEb11XIxhD6mKoIdexsagie6+Vi1x+CNdOhVCZVbHcNDSqTX7vy9f59?=
 =?iso-8859-1?Q?x0WUTrB4W8Tes41QvNKZ2itM7wWhK5EqY3nPkXI8lwujt2WYO1tcA1+FAf?=
 =?iso-8859-1?Q?65sxyVfebJD8CUtG1bJNUOMAl9y2EYz5pTKaOJI+QQ2oOF+HyatFaoY/4c?=
 =?iso-8859-1?Q?+KagPiAR5SK76K0kOM/zvwVVvnwdJR4XSm1YNQTJ0vQTHh3rwuHU6T0hU5?=
 =?iso-8859-1?Q?82UqsjlMJkZ74QR45fDUuBw3ewP3/ea5mzGRSAY82MUf9fI/7oUT7WKMYg?=
 =?iso-8859-1?Q?ej9Fokz9CsXHxmRsfs/en5d+o4PmwthdBPsC71NB79cdA/526AGUAt/+MP?=
 =?iso-8859-1?Q?mNoJhZwXX0XHxKWzSYkH6ucWP1ekAz7lvCn0arUjauWKU3PGFZyOSm1WS0?=
 =?iso-8859-1?Q?+sOZkCivCaFOTICCFHgI1sCRn+gu5eJ7rk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d77073dc-59f3-47df-ddc6-08db3fb1bba1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 02:07:59.6189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2U3/dqB/Spx5aX+ZxyD5N9KjRlvz7tv/smA/p1IFsdUXePSvyfP4iE9kZ9XU9Ofxddg858duXBEXIHs37Obpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6576
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

On Mon, Apr 17, 2023 at 11:17:36AM +0800, Binbin Wu wrote:
>
>On 4/14/2023 2:25 PM, Chao Gao wrote:
>> From: Zhang Chen <chen.zhang@intel.com>
>> 
>> Currently KVM disables interception of IA32_SPEC_CTRL after a non-0 is
>> written to IA32_SPEC_CTRL by guest. Then, guest is allowed to write any
>> value to hardware.
>> 
>> "virtualize IA32_SPEC_CTRL" is a new tertiary vm-exec control. This
>> feature allows KVM to specify that certain bits of the IA32_SPEC_CTRL
>> MSR cannot be modified by guest software.
>> 
>> Two VMCS fields are added:
>> 
>>    IA32_SPEC_CTRL_MASK:   bits that guest software cannot modify
>>    IA32_SPEC_CTRL_SHADOW: value that guest software expects to be in the
>> 			 IA32_SPEC_CTRL MSR
>> 
>> On rdmsr, the shadow value is returned. on wrmsr, EDX:EAX is written
>> to the IA32_SPEC_CTRL_SHADOW and (cur_val & mask) | (EDX:EAX & ~mask)
>> is written to the IA32_SPEC_CTRL MSR, where
>>    * cur_val is the original value of IA32_SPEC_CTRL MSR
>>    * mask is the value of IA32_SPEC_CTRL_MASK
>> 
>> Add a mask e.g.,
>
>e.g. or i.e. ?

Yes, here should be "i.e.".

>> +static inline void vmx_set_guest_spec_ctrl(struct vcpu_vmx *vmx, u64 val)
>> +{
>> +	vmx->guest_spec_ctrl = val;
>> +
>> +	/*
>> +	 * For simplicity, always keep IA32_SPEC_CTRL_SHADOW up-to-date,
>> +	 * regardless of the MSR intercept state.
>
>It is better to use "IA32_SPEC_CTRL"  explicitly instead of "the MSR" to
>avoid misunderstand.

Agreed. Will do.
