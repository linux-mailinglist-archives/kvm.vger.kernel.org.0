Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0E5738567
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 15:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjFUNh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 09:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjFUNhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 09:37:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90866170F
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 06:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687354674; x=1718890674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rX/Jl3SOzN9ThHrdUOJ3QDdoQAgPs95ubDVgZiVYdP4=;
  b=VCPvylO19/XvZwIW4+bAd0Zbat0d4GSOcwRg8UNGoRYbKqbczT08s1uF
   WMgiqtbFAPuOEXVD4/nVa0T7BY5PYVOP228AFNXvr/64SlfOEK8XDzyZe
   7fGOLXAgfgFGzz8fEmbJkYDxWq2RZr+5Qt+gzKqkiNYbYqV7X+e+Wt1jV
   CjZQgW14E4DPnXSA2yWgdi0+F/dMGgu7Uw16OznsIl5ter+nSLXv0DSJS
   ImhPIgwQ2tCdVf+v/MHyfwHyji0JSBbKJIewOdoyuG8sMcJYRfYTZBz1N
   PkJtGhDjeZm65bePruH2vI1/jhfFP1HTL0S9ROgmV5dSjvzfotcxT3/7E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="340518986"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; 
   d="scan'208";a="340518986"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 06:37:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="714492182"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; 
   d="scan'208";a="714492182"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 21 Jun 2023 06:37:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 21 Jun 2023 06:37:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 21 Jun 2023 06:37:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 21 Jun 2023 06:37:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 21 Jun 2023 06:37:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwu69ug4jB9e9VYx768/9B/TabiaEmtRwUeGCZOzvCVDb07jlu0XHmYPnS3UTdVkqKntouWP6hB753LxjPzEqhFG9wPbVFDFS9QypvVGo4NQl/J7vulMKjZQdszbZ+xNFUhyTXTZiM3D69upWB/0SUgUETFVENjJqhEXq6BL6M2Lg3Xr5uGW5zzlR2B7sk8JNdX9MqbnZJj55dGuAmregIkckEelh5M73lT9kldddd2iodittTv9m/LZC+5ACr0zwF8TvEpgurVvrnt/5/XpaR8Rrtq5tqwVLP6hgYcg6Tz6VTdODWHTE+Waz78h9P3Knmu2n15b1SAudgdf4MCcdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rX/Jl3SOzN9ThHrdUOJ3QDdoQAgPs95ubDVgZiVYdP4=;
 b=ZxHt0MVAHcgOBnnYPuqmKYa/KpaMfeTDIUdLBsDcx9yoFcQqSKdPR/rvQkXfOyzz1daQ74mos2Fw0sEEJ1R84ePxlZaAMIcOvVmZAk69K7E95KHrtoCPVlRF0wRVbs+NlxGZJUZ68Oe4r2trgEfti3ra+g3TRlYeaaP3KzwkeJ3rTFUmta30sL19z4b1AiqDlhHsDRbE844NLGROAWsrM48Wqjy9vdKA8yraMwIBUrUYMXtNBCfz82ST573WBAZmWsoRGvmHlab8BQlv8QyrzSNuEXbRsSBKod4Mkf3/hrjTua/qXZJmCUDuG8PDc5sDNnkVsovLz3SGmfQwz40cvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3463.namprd11.prod.outlook.com (2603:10b6:a03:1e::16)
 by DS0PR11MB7262.namprd11.prod.outlook.com (2603:10b6:8:13c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Wed, 21 Jun
 2023 13:37:48 +0000
Received: from BYAPR11MB3463.namprd11.prod.outlook.com
 ([fe80::8625:6a5a:d6ef:b85b]) by BYAPR11MB3463.namprd11.prod.outlook.com
 ([fe80::8625:6a5a:d6ef:b85b%6]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 13:37:48 +0000
From:   "Chen, Farrah" <farrah.chen@intel.com>
To:     "bugzilla-daemon@kernel.org" <bugzilla-daemon@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "sylwesterx.dziedziuch@intel.com" <sylwesterx.dziedziuch@intel.com>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>
Subject: RE: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the
 mac address of VF is inconsistent with it in host
Thread-Topic: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the
 mac address of VF is inconsistent with it in host
Thread-Index: AQHZpEP4nfEnMzHhaEOeRry1LbbeH6+VQjpg
Date:   Wed, 21 Jun 2023 13:37:48 +0000
Message-ID: <BYAPR11MB3463C78AA106C857C265C367EF5DA@BYAPR11MB3463.namprd11.prod.outlook.com>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
 <bug-217558-28872-2UHhTDYwie@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872-2UHhTDYwie@https.bugzilla.kernel.org/>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3463:EE_|DS0PR11MB7262:EE_
x-ms-office365-filtering-correlation-id: 0ec37b36-1f0e-4210-e167-08db725cb3e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mxf9UKr+jLQylE5oRJuYgjzWa1q8U7UXKQQ16B72gcsw/VRi/sse6vQ//vYsteXEoC7XMVU+picZQvzGzLwBEMJIoweiEnRIQ+6qZEE57hlOxIeZESvZVn9PA4btaEJcNa7cJnoL4ySglvKp8+r6pkYJFCia7a5/RZ8Ps7t1qqV/OBmAk2vkhD+kx83GXo1qkNyzgUHwvLbyWJ2s10OA3/gIuR2tJg5I5KMWjCTlEfOzCstvR+S328AHTv4yJZC3qG1EntpHawUgQZ2B6oE/yIJmdz6NlARi/AN3Ae3u6VLeYOSIM2WRsh8TfX5denYZNEx+wiiObCS4RK/wXYLdYG7Y+kT7jnTV9rlt8+mch8eCRciZPr7wUiqJiPzABkNIeNrdmp56SRlNy/ChRtRrWa+C2wtmiGyyqbXiHbSElFdics29z7VLFbt5jICWTVmHMmlEKsW4lQhdgBWa2w1bF3cbhiz47J4ayWGNezj2rm9ANOYaUN/EqTbq1asUWHGbrmNjGfNAOeEJ34PRlQSIxrPqwGM1EnW4NonyrKftSvV/SNlZAtrhOi37jBIdFhxLKhbLE29u0zTgkDC/mZeYlvOwakpTK4ucfxv+b99/1e4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3463.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(39860400002)(396003)(366004)(451199021)(8936002)(66556008)(71200400001)(66946007)(186003)(8676002)(4326008)(66476007)(64756008)(66446008)(5660300002)(54906003)(110136005)(7696005)(33656002)(316002)(41300700001)(478600001)(26005)(53546011)(6506007)(38100700002)(966005)(9686003)(76116006)(55016003)(107886003)(38070700005)(122000001)(2906002)(83380400001)(86362001)(52536014)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkdjSXdSbXc1YUtpcU9ueWV2SzE1VmtpRFVaZ3AraVNnVmdXWi92d0tmcGtv?=
 =?utf-8?B?a2k1QzYybGo1TnZoaUhnRXFGK2pLazJoNjhCdFVCdzZGTkVWNFRiY1VPTWhS?=
 =?utf-8?B?dkNaQUJINFVCWXMzUVZHajV5dHlpQ0I3L3NrTFkwVExyWmVGUFJwMVNpREs0?=
 =?utf-8?B?Smpxc3JCVUZGUTZXNDVXRC9Na2pIUUVlR09GdFF2WFhUdjlWNVdQcjh1cjRq?=
 =?utf-8?B?SXpWT2V3S2tUb2VsSkQreHJyTDJGRXpOajBqOTd1NUh5Y2ZET21NWFcvR0dS?=
 =?utf-8?B?Y09KZUt3TjcxOWRHL0NIS3ROeWh4VHRkWnlrT2gzNG4rNmErSE11MVFUZlFJ?=
 =?utf-8?B?cUNZK2M0Y29lSkQ5Zy82MHVJZnFWdUtSOGR4QXVpaWgzbUcxbEFaU0JEcEoz?=
 =?utf-8?B?c253VU10NnJvUjVLNHQ2ODNDSzZmWDZ2M0tGVWtXQ3o5dkowMGJBQ1BwV1R2?=
 =?utf-8?B?dDNaMXN1YU9PblZ1ZlNGa0pOZ3hiL0Ewa2hjZFd1cnRGSFFXUEk0bFZPR0dm?=
 =?utf-8?B?NlBqS25QUWpKSnhvMmpGdXd1UEd4RnBNa0xHNzBtVDNCVkdEZEpCamJEZUVU?=
 =?utf-8?B?Y2NVKzRzZmUzdjhhM0Jla3RiUVk4YWVIR2tGaFFKUmltVWhvNUtFbnc5SE9G?=
 =?utf-8?B?dUl2czIvKy9GeFZXamtSNk9NNlpWQ2k5VzQxblZDQm41aHhiYzBGWURxSk1k?=
 =?utf-8?B?YWQwL0VBNEViZXY0Y1BpWmw2cHNXdDY5MlN5Z1JkbGJGcUNyMVlTZmYyVVdC?=
 =?utf-8?B?R0x1Zkw5WjV0MFdXdGdpNFhtK25EMlFOWVJyeVVSUnJEZFo1Vm9MU0huNFY2?=
 =?utf-8?B?YjZvMXAwMVlJblMxcHBKdnk1am9HVjBra1JBalJmZGtYSzN2azk0WTZnTFg1?=
 =?utf-8?B?REJUL0N5OEJraTVIYlZKQm1ldmVTcXpmMVFjbXRNeEkwbEthNW4yV09kTU9l?=
 =?utf-8?B?QnZ1dllpSjhjYVIwMUgrbGJNQzFTSzJ5L1VLVzVtR0lmblQ4eUNOUjZ1Q1dr?=
 =?utf-8?B?eXpUenZ6dHRoK0JFR1grRTlXcXJsaHpoemdDRTR1bjFOT2hGZGc5b3JIUWhR?=
 =?utf-8?B?aElOcnY3NSt5US9NMVJZVWczaVFjWUJ6QUtoRXFJRGk4QmJCV21PRVNvZklJ?=
 =?utf-8?B?UmUrYnFDVHZUWDVnRUNmMVRjMk8xZGNOVmZPT09ETkNuUmFGaitOcnZHRXl0?=
 =?utf-8?B?dzd2YWhXUkhOUDFZSWNNQjdlVjFwaktzSFp3NnBHYzY1Q1lRalFIS3M0dUdP?=
 =?utf-8?B?OWE4eWRhOUtaR3E3WWMyRzlTNzZFWXR1Zmd3ejVPTlJpcC9WVTdKa1RzRC9X?=
 =?utf-8?B?VWIxbnhjeEF4S1duMDBkQzNTQ1ZtUDhNNnJ3QTQzUmZNNmdzMTVTek5IenZW?=
 =?utf-8?B?WkNXZUpUZG5admdXRjU3N2pNbWpITGFhVVg0c1FwYnJPWE1uNWlCK1VnNHN4?=
 =?utf-8?B?OFZJc1Q2SjNwblowNjRXR0QwVVBDYzN2bi9LcUxhMG1kd1ZUVWlDekp1MlRM?=
 =?utf-8?B?L3A2RlFRb0ZKWU95VWxrUWQ5UVZOaCsyYldQMXMzWjlucU9lZEZTdW5HOTl1?=
 =?utf-8?B?NzBOaXhHVi9zK05kN0k0NGZmT0ljYWVoa0cxTEpvTFBBTDJ3V0dOeWZpamk5?=
 =?utf-8?B?V01IU0hFbE5EdlpQeEE5NFdhUVZHK3VXUXc4anVnVUlkWDVIb0ZQbjBUSFNQ?=
 =?utf-8?B?OHVLWkk4Rng5aTUyclhwbzR4bjFERGZxVWdXZzZ4eFdCUHZ2cG1sZVd3SlE0?=
 =?utf-8?B?TTBNK29TVXZMNThOb293YWpVU05sbDlZVXlLY1BGYmdOeXAzRmFFNFV1c3Zu?=
 =?utf-8?B?SkJnUWlkYnpObVhUaVJncVAzN3YxN3ZuVFU5Zm9MdWNlanlWQUQ0Zzc3NS9L?=
 =?utf-8?B?WWZPTUR2dThTYmJwWldLY2w2ZU9rNHBpTkRBU0NBclZkZXFQM0VOb2x4THBI?=
 =?utf-8?B?bnEyWlFHVFVCK1hhYThSa2ROUS84NlhXREEzdjRGWWVoWjRacDBWK1FEaUN1?=
 =?utf-8?B?d3VZakZHd1lJUVFVTDg2SXpQdzJldTlkSEt5cmhEZzgvOVhXN3QveDNDM00r?=
 =?utf-8?B?b0t2aXFEVTFPeWZHeDB6dEdOc1NsVDlSZ3RLNTdYUU9mZUFPWWhuWnhKa0Zs?=
 =?utf-8?Q?Xid7eE/1bifn5G5Iz7SwJU5Kv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3463.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec37b36-1f0e-4210-e167-08db725cb3e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2023 13:37:48.3313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6PpEDIgrDy1238U5mkGBiPYA7vWRKXJvAWdd/9cV4gPC0In0tdLfRLA/awnBjyFzNSZQOr+DWuU9i/9/1hb9Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7262
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

QWRkIG1hdGV1c3oucGFsY3pld3NraUBpbnRlbC5jb20gYW5kIG1hdGV1c3oucGFsY3pld3NraUBp
bnRlbC5jb20NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IGJ1Z3ppbGxhLWRh
ZW1vbkBrZXJuZWwub3JnIDxidWd6aWxsYS1kYWVtb25Aa2VybmVsLm9yZz4gDQpTZW50OiBXZWRu
ZXNkYXksIEp1bmUgMjEsIDIwMjMgOToyNiBQTQ0KVG86IGt2bUB2Z2VyLmtlcm5lbC5vcmcNClN1
YmplY3Q6IFtCdWcgMjE3NTU4XSBJbiBLVk0gZ3Vlc3Qgd2l0aCBWRiBvZiBYNzEwIE5JQyBwYXNz
dGhyb3VnaCwgdGhlIG1hYyBhZGRyZXNzIG9mIFZGIGlzIGluY29uc2lzdGVudCB3aXRoIGl0IGlu
IGhvc3QNCg0KaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTc1
NTgNCg0KLS0tIENvbW1lbnQgIzMgZnJvbSBDaGVuLCBGYW4gKGZhcnJhaC5jaGVuQGludGVsLmNv
bSkgLS0tIFdlIGJpc2VjdCBhbmQgZm91bmQgdGhlIGZpcnN0IGJhZCBjb21taXQsIEkgZG9uJ3Qg
dW5kZXJzdGFuZCBpZiB0aGlzIGNvbW1pdCBpcyBpbnRlbmQgdG8gZG8gc28/IE1ha2UgdGhlIG1h
YyBvZiBWRiBpbiBWTSBkaWZmZXJlbnQgZnJvbSBpdCBpbiBob3N0PyBXZSB0aGluayB0aGV5IHVz
ZSB0aGUgc2FtZSBtYWMgaXMgYmV0dGVyIGZvciB1c2Vycywgd2l0aCB0aGUgc2FtZSBtYWMsIHRo
ZSBtYWMgb2YgVkYgaXMga25vd24gZm9yIHVzIGJlZm9yZSBjcmVhdGluZyBWTSwgdGhlbiB3ZSBj
YW4gZ2V0IElQIGFkZHJlc3Mgb2YgdGhlIFZGIGludGVyZmFjZSBpbiBWTSBmcm9tIG1hYyB3aXRo
b3V0IHVzaW5nIHZuYyBvciBvdGhlciBVSSBvciBzZXJpYWwgcG9ydC4gSG93IGNhbiB3ZSBtYWtl
IHRoZSBtYWMgb2YgVkYga2VlcCB0aGUgc2FtZSBpbiBob3N0IGFuZCBWTSBub3c/DQoNCmNvbW1p
dCBjZWIyOTQ3NGJiYmMzNzdlMTFiZTNhNzA1ODlhMDAwNTMwNWU0ZmMzDQpBdXRob3I6IFN5bHdl
c3RlciBEemllZHppdWNoIDxzeWx3ZXN0ZXJ4LmR6aWVkeml1Y2hAaW50ZWwuY29tPg0KRGF0ZTog
ICBUaHUgTWFyIDMwIDEwOjAwOjIyIDIwMjMgLTA3MDANCg0KICAgIGk0MGU6IEFkZCBzdXBwb3J0
IGZvciBWRiB0byBzcGVjaWZ5IGl0cyBwcmltYXJ5IE1BQyBhZGRyZXNzDQoNCiAgICBDdXJyZW50
bHkgaW4gdGhlIGk0MGUgZHJpdmVyIHRoZXJlIGlzIG5vIGltcGxlbWVudGF0aW9uIG9mIGRpZmZl
cmVudA0KICAgIE1BQyBhZGRyZXNzIGhhbmRsaW5nIGRlcGVuZGluZyBvbiB3aGV0aGVyIGl0IGlz
IGEgbGVnYWN5IG9yIHByaW1hcnkuDQogICAgSW50cm9kdWNlIG5ldyBjaGVja3MgZm9yIFZGIHRv
IGJlIGFibGUgdG8gc3BlY2lmeSBpdHMgcHJpbWFyeSBNQUMNCiAgICBhZGRyZXNzIGJhc2VkIG9u
IHRoZSBWSVJUQ0hOTF9FVEhFUl9BRERSX1BSSU1BUlkgdHlwZS4NCg0KICAgIFByaW1hcnkgTUFD
IGFkZHJlc3MgYXJlIHRyZWF0ZWQgZGlmZmVyZW50bHkgY29tcGFyZWQgdG8gbGVnYWN5DQogICAg
b25lcyBpbiBhIHNjZW5hcmlvIHdoZXJlOg0KICAgIDEuIElmIGEgdW5pY2FzdCBNQUMgaXMgYmVp
bmcgYWRkZWQgYW5kIGl0J3Mgc3BlY2lmaWVkIGFzDQogICAgVklSVENITkxfRVRIRVJfQUREUl9Q
UklNQVJZLCB0aGVuIHJlcGxhY2UgdGhlIGN1cnJlbnQNCiAgICBkZWZhdWx0X2xhbl9hZGRyLmFk
ZHIuDQogICAgMi4gSWYgYSB1bmljYXN0IE1BQyBpcyBiZWluZyBkZWxldGVkIGFuZCBpdCdzIHR5
cGUNCiAgICBpcyBzcGVjaWZpZWQgYXMgVklSVENITkxfRVRIRVJfQUREUl9QUklNQVJZLCB0aGVu
IHplcm8gdGhlDQogICAgaHdfbGFuX2FkZHIuYWRkci4NCg0KQWN0dWFsbHksIHdlIGFsc28gdHJp
ZWQgdG8gdXNlICJpcCBsaW5rIHNldCBlbnMyOGYwIHZmIDAgbWFjIDxtYWM+IiB0byBmaXggYSBt
YWMgZm9yIFZGLCBpdCB3b3JrcyBpbiBob3N0LCBidXQgd2UgY3JlYXRlIFZNIHdpdGggdGhpcyBW
RiBwYXNzdGhyb3VnaCwgaXQgaGFzIGEgaGlnaCBwcm9iYWJpbGl0eSBmYWlsZWQgdG8gYXNzaWdu
IHRoZSBtYWMgdG8gVkYgaW4gdm0sIGFuZCB0aGUgaW50ZXJmYWNlIGZhaWxlZCB5byBnZXQgSVAg
ZWl0aGVyLCBlcnJvciBkbWVzZyBpbiBWTTogDQpbICAgIDMuMDM3OTU1XSBpYXZmIDAwMDA6MDA6
MDQuMDogSW52YWxpZCBNQUMgYWRkcmVzcyAwMDowMDowMDowMDowMDowMCwgdXNpbmcNCnJhbmRv
bQ0KWyAgICAzLjAzOTUyM10gaWF2ZiAwMDAwOjAwOjA0LjA6IE11bHRpcXVldWUgRW5hYmxlZDog
UXVldWUgcGFpciBjb3VudCA9IDQNClsgICAgMy4wNDA0NjZdIGlhdmYgMDAwMDowMDowNC4wOiBN
QUMgYWRkcmVzczogM2E6Mzg6Y2E6NjY6Zjk6NjUNClsgICAgMy4wNDA5ODBdIGlhdmYgMDAwMDow
MDowNC4wOiBHUk8gaXMgZW5hYmxlZA0KWyAgICAzLjA0MjI0MF0gaWF2ZiAwMDAwOjAwOjA1LjA6
IE11bHRpcXVldWUgRW5hYmxlZDogUXVldWUgcGFpciBjb3VudCA9IDQNClsgICAgMy4wNDMyMzJd
IGlhdmYgMDAwMDowMDowNS4wOiBNQUMgYWRkcmVzczogMzY6OTE6OTY6OWQ6NWQ6MDUNClsgICAg
My4wNDM3NzBdIGlhdmYgMDAwMDowMDowNS4wOiBHUk8gaXMgZW5hYmxlZA0KWyAgICAzLjA0NDQw
MV0gaWF2ZiAwMDAwOjAwOjA0LjAgZW5zNDogcmVuYW1lZCBmcm9tIGV0aDANClsgICAgMy4wNDkx
OTldIGlhdmYgMDAwMDowMDowNS4wIGVuczU6IHJlbmFtZWQgZnJvbSBldGgxDQpbICAgIDMuMDcy
NTc2XSBwcGRldjogdXNlci1zcGFjZSBwYXJhbGxlbCBwb3J0IGRyaXZlcg0KWyAgICAzLjA5NDA3
N10gWEZTICh2ZGEyKTogTW91bnRpbmcgVjUgRmlsZXN5c3RlbQ0KODczNmIyM2UtZGRkZS00Y2Nh
LTkxNjYtMjYyM2QyZTU3ZTVhDQpbICAgIDMuMTAyMjQ1XSBYRlMgKHZkYTIpOiBFbmRpbmcgY2xl
YW4gbW91bnQNClsgICAgMy41NTAyNDJdIGlhdmYgMDAwMDowMDowNC4wOiBGYWlsZWQgdG8gYWRk
IE1BQyBmaWx0ZXIsIGVycm9yIElBVkZfRVJSX05WTQ0KWyAgICAzLjYxNzE3Nl0gaWF2ZiAwMDAw
OjAwOjA0LjAgZW5zNDogTklDIExpbmsgaXMgVXAgU3BlZWQgaXMgMTAgR2JwcyBGdWxsDQpEdXBs
ZXgNClsgICAgMy42MTgxNzNdIElQdjY6IEFERFJDT05GKE5FVERFVl9DSEFOR0UpOiBlbnM0OiBs
aW5rIGJlY29tZXMgcmVhZHkNClsgICAgMy42MjgxODldIGlhdmYgMDAwMDowMDowNS4wIGVuczU6
IE5JQyBMaW5rIGlzIFVwIFNwZWVkIGlzIDEwIEdicHMgRnVsbA0KRHVwbGV4DQpbICAgIDMuNjI5
MDM5XSBJUHY2OiBBRERSQ09ORihORVRERVZfQ0hBTkdFKTogZW5zNTogbGluayBiZWNvbWVzIHJl
YWR5DQoNCkZpeCB0aGlzIGlzc3VlIHdpbGwgYmUgdmVyeSBoZWxwZnVsIGZvciB1cy4NCg0KSSBm
YWlsZWQgdG8gQ0MgdGhlIHByaW1hcnkgYXV0aG9yIHN5bHdlc3RlcnguZHppZWR6aXVjaEBpbnRl
bC5jb20gYW5kIG1hdGV1c3oucGFsY3pld3NraUBpbnRlbC5jb20gaW4gYnVnbGl6YS4NCg0KVGhh
bmtzLA0KRmFuDQoNCi0tDQpZb3UgbWF5IHJlcGx5IHRvIHRoaXMgZW1haWwgdG8gYWRkIGEgY29t
bWVudC4NCg0KWW91IGFyZSByZWNlaXZpbmcgdGhpcyBtYWlsIGJlY2F1c2U6DQpZb3UgYXJlIHdh
dGNoaW5nIHRoZSBhc3NpZ25lZSBvZiB0aGUgYnVnLg0K
