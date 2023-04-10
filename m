Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB66DCB87
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 21:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjDJTZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 15:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDJTZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 15:25:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB4F19B1;
        Mon, 10 Apr 2023 12:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681154757; x=1712690757;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e62bcKtjXbPeMQGQ22MdpqylAg+rPrS6uX+b4mFgIgc=;
  b=GJGpW7B0PrLyjoKsMw+gEmfT8Xv79MEhQ7t+xOY5x2jsPg7OoJ7snALE
   T8337KRSMZjEPTV2ezT4Wxil16Hzmchb8BZHcnEelHeaUbwI0d4685wrD
   6SDrMfgBDOgF+0cD18Z8QloE6scQCwPVHLw8X+C2t7boL+9pCcwZFPSJb
   tvclL1ZaE6BPJSG4qZ3Sxb25aodkMkQJ9kXjPbdPhmuw7dpBnQWxGeM+Q
   NtjzYM2BxDvVrixMHuKqJDeO/Co3SBKDk+k9CLplRK7dRUwOTajHeS9iU
   5YC8Z1RaFcxQUripmvAvT7CzzcyTkfTxGlkKrOAiY5Mc/JAN4Ln1OQxd8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="327530368"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="327530368"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 12:25:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="832076747"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="832076747"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 10 Apr 2023 12:25:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 12:25:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 12:25:39 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 12:25:39 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 12:25:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aw2uAy2/YOvARmxdsjhPlP1y4AFRUCmx4Gg5iPHtpISAXfg4hPoCodMQMZehyC4ScSwmHc5hfki99XXMU1E0XoK8HYem58Ifhu13GIfohV8g21v0ABf6zU8ZwSCv4KPv0sF8WjhFS29txEKlugsQUExzHZV6eeexdF9HRwiIxOZxJxvHI3PpPC48ukebGTIbOoHG5TiMI/E8xeRZLdP/cIImHcuobe96ja6kT4GSIm1Gd5P2hl+afZI3llONGpO9FF7v+al9LrF4Wge5/0oRhy0E4yv/r/sPcrhx8FOlRkzXuayZd8dtk/HPWwZ33AqIW2+UI98Yt/nxUgi1aG1KpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e62bcKtjXbPeMQGQ22MdpqylAg+rPrS6uX+b4mFgIgc=;
 b=ObyCMzGchPeMoCcDKEZOfp1WdHwpbNPnuicjSWpPOfBav2rryy69V5xSvFlwKGY6KEKDzaVZU+JPtJVA1CyeHFy5XPiUh9qJfKKd2PHM1XMKFQh2EFVp832FHf1H3bfTHEIRLjLptikyO7YIqG/59yCFxCSPQJ9iMI+0eWJifbHpTSa6v4Cnn9eVeSN7Tjr1EISJOT2XEugp2Ua8OZqiDl2l29OS5nitZFtF7NHfBilVyin+bf+cnKtWWdLAsvrmuYw9Z8azPpOyCbgVYyfmcxbdowYPy+tRzZrftR/eYumSqrr0H3rZkEwKNLf88jjhblZCR3TYnEtKFviPEiBpcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by IA1PR11MB7920.namprd11.prod.outlook.com (2603:10b6:208:3fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 19:25:33 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%5]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 19:25:32 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Li, Xin3" <xin3.li@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v7 23/33] x86/fred: let ret_from_fork() jmp to
 fred_exit_user when FRED is enabled
Thread-Topic: [PATCH v7 23/33] x86/fred: let ret_from_fork() jmp to
 fred_exit_user when FRED is enabled
Thread-Index: AQHZZuQAhOn3U+sdnkOeEQpf5aTJma8k40uAgAADRiCAAA/MMA==
Date:   Mon, 10 Apr 2023 19:25:32 +0000
Message-ID: <SA1PR11MB673446F0E92DD8230EE0619FA8959@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230404102716.1795-1-xin3.li@intel.com>
 <20230404102716.1795-24-xin3.li@intel.com>
 <bbde7529-eb64-5454-0984-bfdabac37b64@intel.com>
 <SA1PR11MB673446DC2CFD6DEDF97AC954A8959@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB673446DC2CFD6DEDF97AC954A8959@SA1PR11MB6734.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|IA1PR11MB7920:EE_
x-ms-office365-filtering-correlation-id: e1add122-5203-4a2b-77c1-08db39f95a20
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FvzVj33Tb3kl31YdfhJWVaM0XLw69WqRKjYgmkKQrO49IFZGS4NBJ8671IsgIRaAvyf/tVhvdw04VRM1qhHLLUVzXPoygGbgzIbiBgGfmdwQwmpAo+gB2Pu7qHiuYvaxp1YhQfsaNNMOh6FT0isPlSaiwQcBD00deFjrK48/Ig4HzyIR91ZigWehX5TGr3kM5e1fZK4JCpKzS7Ipnh1BAVdac6SFn1DtLbyYqHOSavK9GvYJKNFFeCgyXY/pvD88T5ZvVttPghXssRqNYd5W1zeB/OQgq2TnFSGywTz2jqrIBQ4y0HP778S+bWEPmsoPn53j81R/3XUERkk+X8zHcnWuhMr3gl8KPj99aX5e8/cBa/dLSQqnrDSITbkPThkE+4VXa9809lnkEAN4rb8yRAxQvpN1w5F9Gzn3IcW6kx//8oNWaesacHNGYa2uPl2jat7g+1rd7PLgiX0ABoYxRXJwatcVMYJOcrt7tCRgry81nxGgAaVPRhf3Q+fRa2HGzFaxxYS9Bwg6WW7Nvs8/N3Q3sXbrhdRpR3qesXiXHNX6RnDVUeXzByeAsUYJxDWRm7JmDbuQv/Da5gdkS0mmJ4AI/+1UWvV4OMAP9sA+y9atr+g7+sY46Lwf6oEjBoT5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199021)(71200400001)(7696005)(478600001)(55016003)(33656002)(86362001)(38070700005)(83380400001)(82960400001)(38100700002)(122000001)(2906002)(316002)(110136005)(2940100002)(9686003)(6506007)(186003)(54906003)(7416002)(53546011)(26005)(66476007)(8676002)(66556008)(8936002)(52536014)(5660300002)(41300700001)(66446008)(64756008)(66946007)(4326008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3dzMUVXU2FQeXo4M1NSRjRvUk1iUlhDQVZIN2VVL2hmZ0hveU11MVo4bGZU?=
 =?utf-8?B?dmYwcjB5elNIdlM2MlFiNDlLYkhaYnd5VWMwVi84SUtySkRzQU5jMlc5MndN?=
 =?utf-8?B?TnlGbGNodnNzTmhkYTE3dkJOYXJkYzJQYUlNeVBaWmpVYk9nbHJUZGw2U2ZM?=
 =?utf-8?B?N0tQZ2tXZFhhOEN3elFrMXRmZHdRQTM2SGt4N2FzN3JzQ3Fxd282M1lVVVJ1?=
 =?utf-8?B?enIwcWdZdThyYyt5OWl5Zk5YeUVXbEVGZkE4UkhURWtyYW9vSWVVNHczSmJ1?=
 =?utf-8?B?ZGdVdHdpdXl3NGJYSkFHL2lEbzVKTnpMMGlpZmc5dWVYSjVCMG1KV0k0STU5?=
 =?utf-8?B?cm1DelNYQ2IzZzNmTzF6c0JFRXJVT3hJcFd2elRNRHo2UGpOOXMwSjBJVVJn?=
 =?utf-8?B?WVdycytzWmNWRTVPYVZadm1maFl1YmNheWhvaDhLVm9XZjJHVE9sVDFUZmlv?=
 =?utf-8?B?L3VBbldZUjVYczFDM1ZWSXh5ckIzSURLd3g5N1FwRzBiajN3SXNKclAzMllU?=
 =?utf-8?B?Y3VLU042em91TU5venh6dGlsTVI2OEVZU1BDYitrYmZ4dHlEUFlMWlpYa1dQ?=
 =?utf-8?B?ZDRoUWNvQVZKTjhiekZRVzVUUEpIN0JITkF2eitQU1FsVGJ4N3JJQUhRTXJQ?=
 =?utf-8?B?UnEyWEVTTEhULzhOS1Mwb3Y5QzNpSlROL1FIaWJ3bVR1OG9TSlNLdEt3M0hv?=
 =?utf-8?B?bm9WMkhNNzJUckw2aHFVa3dwY21Xakc0L05jaWZscmdQU3l0OTFlb09zRUty?=
 =?utf-8?B?M09RUmVqeDNsdGNFMzJVakgwcFJIeFFQNTJQSU5UNVh1Y001TnBTM1JIVG5K?=
 =?utf-8?B?UEpaelJpem1qaFpGNzU2QmtGcnlxVEJMa2psZkY4UmlJMUFUVEVCYVVzdEdX?=
 =?utf-8?B?cTFsS2ZFKy9ZaytUeGExT2hTMW5pS05CSHVpWFN0Wk9TWlpFajcvMDZXYm5r?=
 =?utf-8?B?OXgwMGFPUVREY1lFelpLSWxkMENOand3K2FQdThvQ2VyNFVVTVpVQjY1WU9l?=
 =?utf-8?B?NzVXaEJ6Q2JaQk5FYit4WUFMOER1UkRVU2dDZWdrWVBtaHozKzBmUnpBdThZ?=
 =?utf-8?B?aVNlS1JYejVxbHdmWk9FZTdFQm5yY2srTzBnVG9YMDZCUzhjTVVncERCYjJD?=
 =?utf-8?B?NHp5ajFUVVpZT2Z6UDZYbW1EYVBJd2I0L3lvYjBSTGJiZUdtODJpZEIyUUZR?=
 =?utf-8?B?VERLTWhwRW9oOHFhSXFXanErUGhyYkdWSEhtZzJhS21tQmtYK3NqbjcyTDZX?=
 =?utf-8?B?RVdUYzQvdDcxSHQybmxIQmlPNEkrZzY0dkx2NXBSN0YvVGp1ZEJjclNwMDVh?=
 =?utf-8?B?TXZWWXg0M1U5QW1yZUYxOTlheFZwN0wzWmFad2FFaEpVVzdGWWJ1aHBXTmFz?=
 =?utf-8?B?QmhXR0Z5TXRqcDl0S2JtZTJkaEJ5OEJ2WmJhbTN5MHpGSFhyMS9JQ3ZBamU4?=
 =?utf-8?B?ZkdKdzViYVdpdmZXRzBQNjA5WlRtbysxNkRlMGtUZXlQTzJJNVZrTjBJa0Fl?=
 =?utf-8?B?ZWs0b0ZFNGRGNVVhTVZLbTcyNHdqaWhZU3MxMFFoeVNMVzBCN3NZZEgyWThR?=
 =?utf-8?B?ZXc0M2lUYjZ1d09SdEh1RjU4RnJrYUVxYXFkTUFFcHlYTnhwaTJydzhTYmw0?=
 =?utf-8?B?dm1YcWdCMWtNSmxXeDFaS08vL0xTeUVsZWhJd0FXM0NQVXFVQXdERWc3aUhT?=
 =?utf-8?B?TmZRRG8wMnNOWlppL3NNSFowZTl3T0hsV3ZEUEpoTHdjeEVWZURNdUVsUkY3?=
 =?utf-8?B?VGo4UUVCSzZUMzhKc1VNQUhxeFdhZnJlcXdGY2RXNXA0TTNaTFZMRjhVMGlj?=
 =?utf-8?B?QzUyUndRNHVYK09zSnMyOXp6b2ordlZKcllidUlzQnhROG1ZeVR2TUdNQXJY?=
 =?utf-8?B?dnJURm5mcU9RZ1p6MzdoK1ZoaW5sK040OVVlZDBPYlppamZvSXpiU3N2dW1p?=
 =?utf-8?B?dDdscmRzbmMyTGMzYWRMdUIvaG10MFVpSWdTYXoycmtQMWJGTGhGcWwzcVpl?=
 =?utf-8?B?ZmVvQXI5OHdLUWJFeEg5Qnl6VUpTNyt4eHJ2ZkV6NjMrcE1SY1cxR0xtMDRF?=
 =?utf-8?B?Mzc4NlNyNHA3dHFEeTdUT1BxNzN5cFpZQndvaTFxTW9PdDVQMW5wRGZENHAr?=
 =?utf-8?Q?OO5E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1add122-5203-4a2b-77c1-08db39f95a20
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 19:25:32.4645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a9yNHCZ7L5gS3N05rFWc34Ssz894QLX5WKl+OkAO/Wl0CYrzeIeQvxsviA0GEWwmR8LFelJFBh5FnprmVRwvuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7920
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGksIFhpbjMgPHhpbjMu
bGlAaW50ZWwuY29tPg0KPiBTZW50OiBNb25kYXksIEFwcmlsIDEwLCAyMDIzIDExOjMyIEFNDQo+
IFRvOiBIYW5zZW4sIERhdmUgPGRhdmUuaGFuc2VuQGludGVsLmNvbT47IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7DQo+IHg4NkBrZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnDQo+
IENjOiB0Z2x4QGxpbnV0cm9uaXguZGU7IG1pbmdvQHJlZGhhdC5jb207IGJwQGFsaWVuOC5kZTsN
Cj4gZGF2ZS5oYW5zZW5AbGludXguaW50ZWwuY29tOyBocGFAenl0b3IuY29tOyBwZXRlcnpAaW5m
cmFkZWFkLm9yZzsNCj4gYW5kcmV3LmNvb3BlcjNAY2l0cml4LmNvbTsgQ2hyaXN0b3BoZXJzb24s
LCBTZWFuIDxzZWFuamNAZ29vZ2xlLmNvbT47DQo+IHBib256aW5pQHJlZGhhdC5jb207IFNoYW5r
YXIsIFJhdmkgViA8cmF2aS52LnNoYW5rYXJAaW50ZWwuY29tPjsNCj4gamlhbmdzaGFubGFpQGdt
YWlsLmNvbTsgS2FuZywgU2hhbiA8c2hhbi5rYW5nQGludGVsLmNvbT4NCj4gU3ViamVjdDogUkU6
IFtQQVRDSCB2NyAyMy8zM10geDg2L2ZyZWQ6IGxldCByZXRfZnJvbV9mb3JrKCkgam1wIHRvIGZy
ZWRfZXhpdF91c2VyDQo+IHdoZW4gRlJFRCBpcyBlbmFibGVkDQo+IA0KPiA+IE9uIDQvNC8yMyAw
MzoyNywgWGluIExpIHdyb3RlOg0KPiA+ID4gLS0tIGEvYXJjaC94ODYvZW50cnkvZW50cnlfNjQu
Uw0KPiA+ID4gKysrIGIvYXJjaC94ODYvZW50cnkvZW50cnlfNjQuUw0KPiA+ID4gQEAgLTI5OSw3
ICsyOTksMTIgQEAgU1lNX0NPREVfU1RBUlRfTk9BTElHTihyZXRfZnJvbV9mb3JrKQ0KPiA+ID4g
IAlVTldJTkRfSElOVF9SRUdTDQo+ID4gPiAgCW1vdnEJJXJzcCwgJXJkaQ0KPiA+ID4gIAljYWxs
CXN5c2NhbGxfZXhpdF90b191c2VyX21vZGUJLyogcmV0dXJucyB3aXRoIElSUXMgZGlzYWJsZWQg
Ki8NCj4gPiA+ICsjaWZkZWYgQ09ORklHX1g4Nl9GUkVEDQo+ID4gPiArCUFMVEVSTkFUSVZFICJq
bXAgc3dhcGdzX3Jlc3RvcmVfcmVnc19hbmRfcmV0dXJuX3RvX3VzZXJtb2RlIiwgXA0KPiA+ID4g
KwkJICAgICJqbXAgZnJlZF9leGl0X3VzZXIiLCBYODZfRkVBVFVSRV9GUkVEICNlbHNlDQo+ID4g
PiAgCWptcAlzd2FwZ3NfcmVzdG9yZV9yZWdzX2FuZF9yZXR1cm5fdG9fdXNlcm1vZGUNCj4gPiA+
ICsjZW5kaWYNCj4gPg0KPiA+IERvZXMgdGhlICNpZmRlZiByZWFsbHkgYnV5IHVzIGFueXRoaW5n
IGhlcmU/DQo+ID4NCj4gPiBJIGd1ZXNzIGl0IG1pZ2h0IHNhdmUgYSAqVElOWSogYW1vdW50IG9m
IHRpbWUgYXQgYWx0ZXJuYXRpdmUNCj4gPiBwcm9jZXNzaW5nIHRpbWUuICBCdXQgdGhhdCBkb2Vz
bid0IHJlYWxseSBzZWVtIHdvcnRoIGl0Lg0KPiANCj4gWW91IGhhdmUga2VwdCBzYXlpbmcgbm90
IHRvIHVzZSAjaWZkZWYgaWYgcG9zc2libGUsIGFuZCBJIHRyaWVkIHRvIGdldCBpZiBvZiB0aGVt
Lg0KPiANCj4gU29tZWhvdyBJIGVuZGVkIHVwIHdpdGggb3Zlcmxvb2tpbmcgdGhpcyBfdW5uZWNl
c3NhcnlfIGNoYW5nZSwgd2lsbCByZW1vdmUuDQoNCkFjdHVhbGx5IEkgZGlkbid0IG92ZXJsb29r
IGl0LCB0aGUgcmVhc29uIEkga2VlcCB0aGUgI2lmZGVmIGlzIHRoZSBzeW1ib2wNCiJmcmVkX2V4
aXRfdXNlciIgaXMgbWlzc2luZyBvdGhlcndpc2UsIHdoaWNoIGlzIGRlZmluZWQgb25seSBpZiB3
ZSBoYXZlDQpDT05GSUdfWDg2X0ZSRUQuDQoNClRoYW5rcyENCiAgWGluDQoNCg==
