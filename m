Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EDC71692F
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjE3QYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjE3QX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:23:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C53189;
        Tue, 30 May 2023 09:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685463821; x=1716999821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=x9MXvI5HktxoStyqb+CwpnhiQFlP6fmCYRPlaNDXwq0=;
  b=Cir0XJQ8B4YtCNfKPA2/+/TrMlvY3k90XklQ/UMfHtVBGTMFN2fldS41
   w+9GmT43Tj+l2H21+R9Hy8hLVmqFxygQ2zqPx7N8ml9yk08+LNh42mdeY
   fa48Ju4xwNGjsSOrZoOUqVPiVnuxAYBVlUy/aje4OAkT7eYl0SET3r5Os
   mXt4x4dFRd1VVlfZBNyBVStqK01FsEfNFvyoF5MgRnacMZ38gLHunCpIR
   3oiBDb0AUbqFV5VD9K5uInhrR/LZ4hvptnMRtfm4YqmKJbydpEuXS10iS
   nz7305m73vT/h5eIaoYZtKwF6noU6eIo5YoqFGM6MNwvti45EBvGNbrfd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="441328369"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="441328369"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 09:23:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="850848040"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="850848040"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 30 May 2023 09:23:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 09:23:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 09:23:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 09:23:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 09:23:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IsjHrH8BHNheqbYmCzAUpyOJNIUnadbcSm1qSeAfyqWd1whzOw2jbnzCJetaGP5ctQnhXAInRrxl8UMySINtl1ssxGOzDqYM49YXmB1AtMRco0riCRhDa7bQeu8ZtH8OF7KrCYji7v/uRE96MYzaW286KtGuFGezSJyasElYJrQ4z5zkZiICDxi63Gbf4RMNYfCdvSReY1YZtKlF0motUFHS0cOYbEf5EN/BCyXU4EnK4DgMDrN81Sy80SKZgLJwoTfVUBGn27wJa8+B4jitbKEPiD1zvUG/JqHL17VoS+8o8ruEXZi9hCnnYCvLtqt39biBatCH59khqRDlC1f+GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9MXvI5HktxoStyqb+CwpnhiQFlP6fmCYRPlaNDXwq0=;
 b=kK8xDJABZwM6zk/A+VK63cUXvKkeVOOTf3pGno+EDOfHUZxo77rzFUeE55eRyyHxBP6xgOPWRdjKSJYmO/vOM/BzeVu7sWtVEnUu7Oh8r2rQ0SEjuqFgdsRJFZYHogNWZRr5Bp5X3INPMhLGJ4gVdOkf/Q7IZocqh2EdXKWnfEWiULgst7m+kpVZ1L+53h57ZmFhU3FUWAw/sBbel3wPK4TbRj1bIQkvVwW1gp46xnwH+x1lMh5pUR3VwXwI86XPbztcG4rp2MSLs6kHybwiDaQyIgQ8jmBBxKiXoX348q6HnJNVAMlcm6OgWdwo/f2kIz6X7bDPecgwsjM/qRmNbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7172.namprd11.prod.outlook.com (2603:10b6:930:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 16:23:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 16:23:22 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "mic@digikod.net" <mic@digikod.net>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "marian.c.rotariu@gmail.com" <marian.c.rotariu@gmail.com>,
        "Graf, Alexander" <graf@amazon.com>,
        "Andersen, John S" <john.s.andersen@intel.com>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "ssicleru@bitdefender.com" <ssicleru@bitdefender.com>,
        "yuanyu@google.com" <yuanyu@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tgopinath@microsoft.com" <tgopinath@microsoft.com>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "will@kernel.org" <will@kernel.org>,
        "dev@lists.cloudhypervisor.org" <dev@lists.cloudhypervisor.org>,
        "mdontu@bitdefender.com" <mdontu@bitdefender.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "nicu.citu@icloud.com" <nicu.citu@icloud.com>,
        "ztarkhani@microsoft.com" <ztarkhani@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Thread-Topic: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Thread-Index: AQHZf2Ve5xw6RDm4tUGLnlOpizAoCa9qHQcAgAEGdICAAalfgIAGWnSA
Date:   Tue, 30 May 2023 16:23:22 +0000
Message-ID: <fd1dd8bcc172093ad20243ac1e7bb8fce45b38ef.camel@intel.com>
References: <20230505152046.6575-1-mic@digikod.net>
         <93726a7b9498ec66db21c5792079996d5fed5453.camel@intel.com>
         <facfd178-3157-80b4-243b-a5c8dabadbfb@digikod.net>
         <58a803f6-c3de-3362-673f-767767a43f9c@digikod.net>
In-Reply-To: <58a803f6-c3de-3362-673f-767767a43f9c@digikod.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7172:EE_
x-ms-office365-filtering-correlation-id: 8f4b5d35-bee6-4765-25fc-08db612a2ff9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YX9qeLlW9DFH5Keokrei0vuCHyw9t9QA/SZjW2AFBeYVC9TWzOEU+ByQbtuHzJ0A6EL7ONKXFgqJ2j4mxVCLJeUjh5PLtETEgiFZ4I8QWgvTpPex3BvJh4jHK7rA2zCzAyHAq+cs+8bDLqTlh0jrdEj+JnNY/m3pkvgvBiioiTRMJEbaT8eb06bQm+RTzDv9Oy5POZy39cMeExa+Bks9+vRbvVm6BNngtec6u2YmJnZVVZgAHB6VWQRiwNoNjNK4O4whZ8TVm284YHr8xxwIg4F5GTTEfupXMy7W/eFTd+vJZxhOoZ3iHeLUV78r1y+7i0glHk49z8OL4MNnl2dyvPqwz070snQjAziCLodaWK0C5BFFIQqM/BFL8Tl8+4yBJRs1A/F20awtTowCFEIRWo4fV5WgpWEFdVVjj8N2sl/KJSMRYV5kAjTCJQp45uVsdwU+O9r5JVp46qCWMpOqBn4O+1oGVaOYYOAlHodGh0QijmCPCvlxCtGruoXMb3qz3Dq9pmELyhs++WvLNQMasY3MSGXGhX8x9cG7KwK6IRejZu5RmfIDHvUr4NFPeia2YeJPdwu2/QZ9ler4JaXGyFtbdY3+FBZLpY7vxQKWNKZzttUDdAMJ9Xx/NzTUrd1x79Xdb4KBaNciyOGK2m/cqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199021)(186003)(2616005)(38100700002)(41300700001)(83380400001)(6506007)(6512007)(26005)(6486002)(66574015)(478600001)(110136005)(54906003)(71200400001)(921005)(4326008)(66476007)(91956017)(66556008)(66446008)(82960400001)(66946007)(76116006)(122000001)(64756008)(316002)(8936002)(8676002)(5660300002)(7406005)(7416002)(2906002)(38070700005)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NThiVktseEF5UFJpNTVobyt4U3V3ZHpveWs2SndYa3lHeW1WSW90cGVHTndQ?=
 =?utf-8?B?R0RLaDlhZlViT2ZnRVFTK1F4Sjd1aEw5R0wyRkpCVTh6NE9yOE9XU2J6enZp?=
 =?utf-8?B?RWduQWJpT3kzeVBVbU8vODUxMnRMeUZPR1hZUTF6Z1dzc2pPOXFXZkk1NXN0?=
 =?utf-8?B?R3hJK3IyM0p3T2RJL3cyRkhIU2JZOURXOVdkQWt6TWdRZVFUWEZsbjhERFVs?=
 =?utf-8?B?RmQ5MGQwRmNnV2pKU3p1OC9hS05qbUVOdnNscVdHdjVSdWcyZmlqQ3BxUTdr?=
 =?utf-8?B?aTcvS0NXWml6MU5Vb0ovV1JJYzYzcWliZzhiKzV6SUhEYmdYYW80UEZiRFRY?=
 =?utf-8?B?dUVsQmxiSjgzWnc3UzM5cjEyYTJmakEvNEN5OGVpRUlUUzZOZkdNc2Q5amsx?=
 =?utf-8?B?ZWIzODlJNXU4VVQ3SHdyWEw3RzVaTXFyQ3M3ZE91bEtia2xaTXF4N1dXaldu?=
 =?utf-8?B?d3dQWHVtZmxrdkxlTlJ1eWoyemhTZjBDQU94RVpSTDJaWkN6Z3pMTTh4dVpj?=
 =?utf-8?B?MDhTVWRYcUdZdGNQVEIwR3pOcWxFL21vbXdYMndGelg3ODlNdndoZlQxNnJI?=
 =?utf-8?B?VWdaNHNJWmJLUE9QdFM3cFFSeE9vdFZkRGhVSFE0ZVVhbjhwa1pmKzhnWUZy?=
 =?utf-8?B?TCsvcEk3OWJvbGFsQk1jdnhCcFl3T2V1eXIvVVhxMmFLanNrVWZiR1RGazhh?=
 =?utf-8?B?VlpPNWl6YzByeGFmK205aTBrUHA4bS9xSEdiZGdGWFFvOS85T2xrT2NpK1Ft?=
 =?utf-8?B?Tm9vL3RWcVRaR3NwTU1IcTN5bjZDZmZha3RGZVZrNk1wQTFnOU5Xa3lYanNi?=
 =?utf-8?B?Rk00ZGh3ZS9yNmI1NVM5UllNVkdmaDVUNVJpQXF3ZFRnQ1dnZjJWYjFuQWxB?=
 =?utf-8?B?RE41L29taUR3SU1TSWUwbUtnMmg2dFhHa1VwOVQxTTB2TjRBWjZsL1FtQmNi?=
 =?utf-8?B?Y1JwZ3JUNmEvL0Zud3NBMXVxZUs0MndSYUdyUlZvR1huL2czL2NkWXBkSDRD?=
 =?utf-8?B?aGlqMEk3aUVlRE81dytZdStMMkhZNTh1U2xzNDNURVo5ZjJqeGlYWTZmS3d5?=
 =?utf-8?B?a0sxR1lsbGtkbXh2V1lXYmpKdHFTN0FucDYrNXNWSE14N09zTWVFczhsYWw2?=
 =?utf-8?B?YS9MTGhzYUdYdVdOZkhFS1ZOcjZDUmxNMkV3czlYdG4wWmhyUHdtbVR0YmFs?=
 =?utf-8?B?dWI4SnVpQjJ6VXM1NGlJVnpTM2JYTjBSdTlydk1UMlBlb05tMzNwTHI2S3g3?=
 =?utf-8?B?MFFSclZFcHJCY2tLOUNrNVduZ2NpYkYwWFVxc3UyRmRNd1FmQ0UzcmtQVzY4?=
 =?utf-8?B?bUpTY0U5Wm1oMEJJYVBRRkdFK2dRbmF5OXFwWU5hMHgxMVdrcFdNRUNITFBn?=
 =?utf-8?B?SC9oU2xZVk5BS1k3VU5DSXo1SGh0ZUEwdlJIaG1RMGptbi9XLzl5d01jbzRY?=
 =?utf-8?B?c1B5VzBvdFFvZFQrRGM3ZERFa0l4WW0zQXRuYVVPb1hsenpNS09ZczIzZWl0?=
 =?utf-8?B?SXd4Z3pibzFsWXJBVXhiYXUwam5HS3puQThqMDg2NmljQ0tqYXlFdmsrZXNG?=
 =?utf-8?B?TjBqclJCbTlkaVp4emQ2VHEvUEE4aElGQmU5dytqOWNxd3dqenlPNnkwMi91?=
 =?utf-8?B?ZjJrYlBjUVg0aFRibllkV0k5TDRCajQzNHhNVE1VSDJzeVdBd2Yzd3l3MjhV?=
 =?utf-8?B?QWhVZ3J4eDFlTzY2N3pNZnNZcktPSHJWUXFPWW9mRUUwZDZHdXJxdWgvUk11?=
 =?utf-8?B?TkRsQXZqT2RzamN3S1RRZ2gveFROTzFIcUE3RW40bFYxZHhuYlNxQ0pxTVUz?=
 =?utf-8?B?TjVaQ2hURGRqSzdnMk9XSEVld2xRZWV1S1FmQk95d0hkRWxZUkFxcVpXKzVt?=
 =?utf-8?B?TEhYaG01NHhBTTIyelhBcGlrL1VOa3hpT3pYUlJmbm0wMURkeFRhOG1XQjk3?=
 =?utf-8?B?ZG1reHpqSEQ3MnZsZ2ZqbDR6dVBxbFZ4Vkc5ZFc3YmlMWU12elpTNnM4QVNq?=
 =?utf-8?B?a242WUs5QzVMVG5IVmJ1RGpNU3JNSmVGUWJMcWtyMk5RSS9jRVJuZDBCdXg1?=
 =?utf-8?B?TUYyMnQ3SGdkbEpQajZEUHJsWkx1THFVU1h0bDVTVkU1VjN0QlFHVXdlanFw?=
 =?utf-8?B?SVRpMzU5QlZONm1VWklpZmxqaXVTSVRkWXdqak9WdE05cmhtLy81eFB4VE5N?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A1BBC9128CF3A4A9AFCB7DF898647AD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4b5d35-bee6-4765-25fc-08db612a2ff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 16:23:22.4146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wt9+Xdtquva4HMsuEq9CJzIi1L1ExpeP/Ljhz+DlY9QclYD7odzMJUX9PibUrW/obiBsmUGVoIG9glyjrTDAe18olIYWtMPIb9ij2hRUMZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7172
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTI2IGF0IDE3OjIyICswMjAwLCBNaWNrYcOrbCBTYWxhw7xuIHdyb3Rl
Og0KPiA+ID4gQ2FuIHRoZSBndWVzdCBrZXJuZWwgYXNrIHRoZSBob3N0IFZNTSdzIGVtdWxhdGVk
IGRldmljZXMgdG8gRE1BDQo+ID4gPiBpbnRvDQo+ID4gPiB0aGUgcHJvdGVjdGVkIGRhdGE/IEl0
IHNob3VsZCBnbyB0aHJvdWdoIHRoZSBob3N0IHVzZXJzcGFjZQ0KPiA+ID4gbWFwcGluZ3MgSQ0K
PiA+ID4gdGhpbmssIHdoaWNoIGRvbid0IGNhcmUgYWJvdXQgRVBUIHBlcm1pc3Npb25zLiBPciBk
aWQgSSBtaXNzDQo+ID4gPiB3aGVyZSB5b3UNCj4gPiA+IGFyZSBwcm90ZWN0aW5nIHRoYXQgYW5v
dGhlciB3YXk/IFRoZXJlIGFyZSBhIGxvdCBvZiBlYXN5IHdheXMgdG8NCj4gPiA+IGFzaw0KPiA+
ID4gdGhlIGhvc3QgdG8gd3JpdGUgdG8gZ3Vlc3QgbWVtb3J5IHRoYXQgZG9uJ3QgaW52b2x2ZSB0
aGUgRVBULiBZb3UNCj4gPiA+IHByb2JhYmx5IG5lZWQgdG8gcHJvdGVjdCB0aGUgaG9zdCB1c2Vy
c3BhY2UgbWFwcGluZ3MsIGFuZCBhbHNvDQo+ID4gPiB0aGUNCj4gPiA+IHBsYWNlcyBpbiBLVk0g
dGhhdCBrbWFwIGEgR1BBIHByb3ZpZGVkIGJ5IHRoZSBndWVzdC4NCj4gPiANCj4gPiBHb29kIHBv
aW50LCBJJ2xsIGNoZWNrIHRoaXMgY29uZnVzZWQgZGVwdXR5IGF0dGFjay4gRXh0ZW5kZWQgS1ZN
DQo+ID4gcHJvdGVjdGlvbnMgc2hvdWxkIGluZGVlZCBoYW5kbGUgYWxsIHdheXMgdG8gbWFwIGd1
ZXN0cycgbWVtb3J5Lg0KPiA+IEknbQ0KPiA+IHdvbmRlcmluZyBpZiBjdXJyZW50IFZNTXMgd291
bGQgZ3JhY2VmdWxseSBoYW5kbGUgc3VjaCBuZXcNCj4gPiByZXN0cmljdGlvbnMNCj4gPiB0aG91
Z2guDQo+IA0KPiBJIGd1ZXNzIHRoZSBob3N0IGNvdWxkIG1hcCBhcmJpdHJhcnkgZGF0YSB0byB0
aGUgZ3Vlc3QsIHNvIHRoYXQgbmVlZA0KPiB0byANCj4gYmUgaGFuZGxlZCwgYnV0IGhvdyBjb3Vs
ZCB0aGUgVk1NIChub3QgdGhlIGhvc3Qga2VybmVsKSBieXBhc3MvdXBkYXRlDQo+IEVQVCBpbml0
aWFsbHkgdXNlZCBmb3IgdGhlIGd1ZXN0IChhbmQgcG90ZW50aWFsbHkgbGF0ZXIgbWFwcGVkIHRv
IHRoZQ0KPiBob3N0KT8NCg0KV2VsbCB0cmFkaXRpb25hbGx5IGJvdGggUUVNVSBhbmQgS1ZNIGFj
Y2Vzc2VkIGd1ZXN0IG1lbW9yeSB2aWEgaG9zdA0KbWFwcGluZ3MgaW5zdGVhZCBvZiB0aGUgRVBU
LsKgU28gSSdtIHdvbmRlcmluZyB3aGF0IGlzIHN0b3BwaW5nIHRoZQ0KZ3Vlc3QgZnJvbSBwYXNz
aW5nIGEgcHJvdGVjdGVkIGdmbiB3aGVuIHNldHRpbmcgdXAgdGhlIERNQSwgYW5kIFFFTVUNCmJl
aW5nIGVudGljZWQgdG8gd3JpdGUgdG8gaXQ/IFRoZSBlbXVsYXRvciBhcyB3ZWxsIHdvdWxkIHVz
ZSB0aGVzZSBob3N0DQp1c2Vyc3BhY2UgbWFwcGluZ3MgYW5kIG5vdCBjb25zdWx0IHRoZSBFUFQg
SUlSQy4NCg0KSSB0aGluayBTZWFuIHdhcyBzdWdnZXN0aW5nIGhvc3QgdXNlcnNwYWNlIHNob3Vs
ZCBiZSBtb3JlIGludm9sdmVkIGluDQp0aGlzIHByb2Nlc3MsIHNvIHBlcmhhcHMgaXQgY291bGQg
cHJvdGVjdCBpdHMgb3duIGFsaWFzIG9mIHRoZQ0KcHJvdGVjdGVkIG1lbW9yeSwgZm9yIGV4YW1w
bGUgbXByb3RlY3QoKSBpdCBhcyByZWFkLW9ubHkuDQoNClRoZXJlIGlzICh3YXM/KSBzb21lIEtW
TSBQViBmZWF0dXJlcyB0aGF0IGFjY2Vzc2VkIGd1ZXN0IG1lbW9yeSB2aWEgdGhlDQpob3N0IGRp
cmVjdCBtYXAgYXMgd2VsbC4gSSB3b3VsZCB0aGluayBtcHJvdGVjdCgpIHNob3VsZCBwcm90ZWN0
IHRoaXMNCmF0IHRoZSBnZXRfdXNlcl9wYWdlcygpIHN0YWdlLCBidXQgaXQgbG9va3MgbGlrZSB0
aGUgZGV0YWlscyBoYXZlDQpjaGFuZ2VkIHNpbmNlIEkgbGFzdCB1bmRlcnN0b29kIGl0Lg0K
