Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556E66AB86A
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 09:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCFIdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 03:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjCFIdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 03:33:47 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A0F211EE;
        Mon,  6 Mar 2023 00:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678091595; x=1709627595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gfgX1upxATdoTveVcHbVC1mKTxnuwhlvQsYAa52QqTw=;
  b=k6Cs+hHXOkymZlnCACoRcdOvCYbOqNnBKw+p+Gjgz2EgHb3USX+rOT/a
   oEQFPZ1P+Q4+3x6ygcbq+HsK8HqoINKhzickecw0fJin+VAjEGfaPOiF8
   ZY2gdPyfBQbvDCEzz759ICcmUZvJ8GzARsLkPNS9a7XMmYHdymXq6YrQ1
   bjbBtSAybZxc9RSCj/RNBxt7+wFl+Dx+kD2UaGSwCdaQsEOoZCBW071Wm
   N+KBbqQfUL3rBbL5xZWLmp+D2ODYMKgf/xU0fJapXPFQL+OYlKqVNiAzj
   ie2atSxyQkhcYpw9RzZ2HbucJ5y4Cvdo1jPIZZ22klNDmYy7RZWv3N91W
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="335523195"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="335523195"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 00:33:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="819229452"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="819229452"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 06 Mar 2023 00:33:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 00:33:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 00:33:07 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 00:33:07 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 00:33:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjKEYKXwaeGHJ8QHd7SWqnZDK7RkctMMcOGfAbjR9GXs6JXn7xRgSyXLlOw4eViiF/bC9Q73qnGNH+ElC6SeyZmFp0ruvn5XsnsnVZjVd+HpxXU+z3KGqdgMEZAGUcOt9tzBefXdCIP1G542yOUi70+gicT0COJRwQoVm4XPbHaQveUHL7Y5rnQuzWPOjmvDmIW9jUqlJhA0Ktw4pDLYDUqpD3aAGeWoj+/XQig42i5vbzVVg3h1X52PV6VVi4nqFPf194AP7W+3gukL24PzlFCjx+S8dZmQYa9S17uT8bMXRFz8OxKpm56CccvlGAI7qUnebGnHZf71mqttpGEMZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfgX1upxATdoTveVcHbVC1mKTxnuwhlvQsYAa52QqTw=;
 b=J1hTsL29TSAKzugoIF23D3F7hsqR1UwwSN/sbrJ4W2x3tHMNQhuWhD/HUpM7WQudX3z+kTPEsaasr5VntrHo2Mt9axRrdw4BpdZvbpXBIiYgRZZgdJyprLYzqFRWV2snPxfvglwAVZcKyO0XW//AwAnLU6JSHedpkM0NjlzMlrOhuUzt+RWCPHngDR8buYQ/T+7NMu86jK7ohVcod9ZlWn/eMiYIo62t+TX2oQIyz+mpuTez7jj2Iue1E1UIaa+9qg+sbG50v30tDf4f4A9Tj0oap0VHfVqERsDwq/BuYSvWRQHN4hko13we+Sm4HMOWI8krdc1J6jsfzjTg+w9Ttg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6270.namprd11.prod.outlook.com (2603:10b6:8:96::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Mon, 6 Mar
 2023 08:33:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 08:33:04 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8ggAETHYCAAKz6AIAC3GEwgAFJowCAAAHdAIAAAfPA
Date:   Mon, 6 Mar 2023 08:33:03 +0000
Message-ID: <DS0PR11MB7529CB36BD052408A9D11418C3B69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
        <20230227111135.61728-10-yi.l.liu@intel.com>
        <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZACX+Np/IY7ygqL5@nvidia.com>
        <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52768A29E00D8FDCB9E6B4EB8CB69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BN9PR11MB527691C6CEA8A1E120F105D38CB69@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527691C6CEA8A1E120F105D38CB69@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB6270:EE_
x-ms-office365-filtering-correlation-id: 56150675-55bb-43cb-2ec2-08db1e1d6747
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: onKuAQB7OXwG/8R/FGEdeSQHwED95WVvpvohIDO8hgLUuJmKRaycHaamD8nfbv/QDCV6wOtmaALdj6jSJbM61hsJFo1h7VrVjmK0rk4YEpLygfm8zEb+oj6UHao5pUAtqubTh8Kiduui0h48NedtBvuxQNc327izxQ7QHXps5KE4H4oLhjqcMWE0rbASvP3NtJbSmsS3+k/yneHypCjlzWERm0jUwUWvp9yOd2vDhW5qdog62EL+rvBc56Rmuns9GNFW6GKqJZyapcr9jkfFtwL3+Qd+ScH7ei76DSWyX9yZjDc3N8WEbKrFXEEPc/WAuPHmQo91fP/JGNrmHxYyfHupfPEr5P54/lS3nyqGuV8zocx/zR+8pCIU87HxztaS6ZJXar2O6CgF629oxJDB1KVdJcYgrTuMiqRoTSzIsD0alw8e9UmXNlKG1xGwQDXNqRkmaMUmTLFAim+VU/Q6nF7WVq8OW7d2lvpTNtn5W49I+8eRU9DKUVzrWxp7sSVzFDkMLk+wquA+FjC+MDro/TPYOTwJdViyBsIPoPYEA2HHUdo7NovRJzYVk71yxZaK9S2HzjhQGYX9ep84YiHSQubk8ASqB27HrQ2pNcmwQglGXOhxsjRvi7gnX6N8hXZ0vhfxuxR8MoE74DRYuUkpvnLDyuMdxdya3xlGFamnlxl1SZF1PcqFoQzNNSbVAfZ9sA1nk5AKyFoUhJDgSQVcygoogsmtYI3PhpCUsngAchY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(6506007)(38070700005)(83380400001)(86362001)(33656002)(122000001)(55016003)(82960400001)(38100700002)(9686003)(186003)(26005)(41300700001)(66556008)(76116006)(66476007)(66446008)(66946007)(64756008)(8676002)(4326008)(2906002)(8936002)(5660300002)(7416002)(52536014)(478600001)(7696005)(71200400001)(316002)(54906003)(110136005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3lCNlgvYko5OStycS9QMlU4dTU1czgzZXRxL0pybzgxdWZWbG1NZk5NTU5M?=
 =?utf-8?B?RXJlemlJOGxjYldFWjVCZWQwWmFzejcvSHJBMHRvektOQS9FZVJRbWlVM0Vu?=
 =?utf-8?B?aGZXTXpiUURPZjFsckQ5VnhOWWlMT2oya0o0L3VuSmpOQXBtNmQrQkw3WlZh?=
 =?utf-8?B?eEltUGNiVXlZOXk1SjZQdjdPM05uOEU2TFZzeE1Vb1ZXTjRDck1QLzQrRHdE?=
 =?utf-8?B?aTBHb0RkajIzLy9WMSt3bVpUS1hzY3VXcjJkNURYbW51NEtCS2xLZ2k4SnpH?=
 =?utf-8?B?QWlOcEtDODZCeWZud3M3MENGZFVpRUNRZjBqS3hZb3k1cXozNUY4Nzh2TmhZ?=
 =?utf-8?B?eXVDMzE1S1R4ZWQ0ZWMwV3UxbXlleVhrUC9hdW4wVFpMczRrYjdCcXpuNng4?=
 =?utf-8?B?RjZSZ2NMdi85dHppZnpWMXkwQit3b2wrbDl5NGp2L1NFQU8ybCszdktHNmsy?=
 =?utf-8?B?Rk1FeUtlSFI0cUc3NDREOVQ1T1N2cjVSVTFTZmNjSUp6dGNza1JtazhIcmgz?=
 =?utf-8?B?S2VEeGhia3BUdThxYUxaSk5VUW5mL09GcFpCUjUvVXhRVlpiY2VmelhtbC9I?=
 =?utf-8?B?dHdvaTRqNTBiWS9oWkF6b05MQ1l4RjUyS3Avb2poalBMQ285M29yZFpGWXM1?=
 =?utf-8?B?M2JyRjlxWlFzOXNzcjRiTSt1QzBWTXg1M2pJMEp1S0hNVEhpd1cyc09kSmp3?=
 =?utf-8?B?T1ZqdFlKeXQ1eURTd0NGY2FDZHFmUEZySlZhNkhvaGYwbC84ZDhGQ2NnV2J2?=
 =?utf-8?B?RlFGdDNwMnlSQjBCMjRwazNnS2plekZsWGNGUVpIdU9Hd2JrNVZudmhPd0dR?=
 =?utf-8?B?dmwxRUpwbnMvd0JGbFprYU1qbjZWS3hLZzJkSnJhVkYzT3dnbmdwYm02OVRB?=
 =?utf-8?B?MFdYY3pkWHRzWUJ6MkcwZXlsNE9wYkx6TGFZMXd4Sit2NWdBUXBWQjBNRG4x?=
 =?utf-8?B?SGhoNkVPTHowazFMNzZ4Z3ZSU21Zbno0Y1RXMFhXMmNXbXdJYzEwNm9aSUhq?=
 =?utf-8?B?T0xqaFdPT2RvMStYZWFSUUQwRi9EczhGdnlPWkhJT3BEMjRiZHF1UjlZeTVm?=
 =?utf-8?B?clEzSVovV3QwUm9OUXgrejNOdThNT0ZLVzV6dFBOUUZVQjNJaStlOHpVaGtL?=
 =?utf-8?B?MXp1TEpOejlUSzRLbUNLOE8ya0dNbWFhUHo4Tnc0ZDZvYnB6amJJMG8xMUoy?=
 =?utf-8?B?Y1B6QW5QV215VDl2NWxFOVhjYjQ5RjZ2SUNPZVpqdThabE9TVEJPNEdTOS80?=
 =?utf-8?B?T1hnTXloK2Z3ZTRwekI2bW5LRWUxQ3FsbHloTVlVTC9nc1FuWGJobkJDT0ZW?=
 =?utf-8?B?UGRNUmVtSnZRNW9DS3hPYThJellsTGZNb2RlYkJROGhWUEdOTjZpbE1ERmo0?=
 =?utf-8?B?QXAvVXJtSGVNQnkrTXUxdS96THRzWG02aE9EZFpzckg1YU1OQlozSUU5RFpp?=
 =?utf-8?B?K1paZll4bW5BQzdTOTNRRFRrNFNBd0JpaEFOK1ZTVW05OEtGeDhhWFhteFlG?=
 =?utf-8?B?c0hwTW53QmtSY0VlaTNzNzlZY051WVlxdnVKK2V6VmRvNlFvc0owTlA5NUVG?=
 =?utf-8?B?ZE9sV2tTNDRyYjcvVWRLcjlDc1ROYldaMlBSNU8zR2t2NmdkcDFvWHNPeUdG?=
 =?utf-8?B?aDRWWTQwVGNFczhBak9XajJIRi9OaktDOG1BZmUwcnBXczFkWTdUOGZHUHlK?=
 =?utf-8?B?WmZkUWhOYkFQdkJzSGZsOTNDNCtmbUZDQ3F0b1JpU0Fmblh3MkV1WStuSllH?=
 =?utf-8?B?QjlEd2JFaHV3ZjJqenV0bE9sL1BkaHJjZ3ZCSDhtcXhMUnptOWhyQ004WUFC?=
 =?utf-8?B?bThYVGthOGdxbWNzV2g4WHMxWklNNWJYSko1NTBSWEE1azVEcFNJZXlwODFV?=
 =?utf-8?B?cGdGT2o3T2E0em4rZEZjM0lGYWNQSlJqcUhBSzZDdlFzY20wM1pMRVVaMm9y?=
 =?utf-8?B?eHByalZNN1RZU1NoQ2ZDamw2bDlhelhvWmowa0VyWS9waWt5OHZiREdJTWNZ?=
 =?utf-8?B?VE5XdjZreDBWc2Q1dDRoVjdUUnpQODVNdmdKMDI4NUV1Zm5YYXBGNTR0bEVL?=
 =?utf-8?B?WnR2bWEzL1hoTzNhemR0YjczVFN5TTZzd2x5LzhZb3g0VDFRSFJtRElmeGFo?=
 =?utf-8?Q?ZP0QvBgGiOG7al+vtB6eZ3HxA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56150675-55bb-43cb-2ec2-08db1e1d6747
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 08:33:03.8191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qgD9sdVJ1dKqWyxarf5cnfMAmhmO9hN5DMmIAb0yPQVsPtCWhKwJ7zOHNuryxXzV+ISNiQu3L0ASNAUcPunDKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6270
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgTWFyY2ggNiwgMjAyMyA0OjIzIFBNDQo+ID4gRnJvbTogVGlhbiwgS2V2aW4gPGtldmluLnRp
YW5AaW50ZWwuY29tPg0KPiA+IFNlbnQ6IE1vbmRheSwgTWFyY2ggNiwgMjAyMyA0OjE3IFBNDQo+
ID4NCj4gPiA+IEZyb206IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+ID4gU2Vu
dDogU3VuZGF5LCBNYXJjaCA1LCAyMDIzIDEwOjQ5IFBNDQo+ID4gPg0KPiA+ID4NCj4gPiA+IEhv
dyBhYm91dCBmYWxsaW5nIGJhY2sgdG8gcHJpb3Igc29sdXRpb24uIEFsbG93IHVzZXJzcGFjZSB0
byBwYXNzIGEgc2V0DQo+ID4gPiBvZiBkZXZpY2UgZmQsIGFuZCB0aGUga2VybmVsIGp1c3QgY2hl
Y2tzIHRoZSBvcGVuZWQgZGV2aWNlcyBpbiB0aGUNCj4gZGV2X3NldCwNCj4gPiA+IGFsbCB0aGUg
b3BlbmVkIGRldmljZXMgc2hvdWxkIGJlIGluY2x1ZGVkIGluIHRoZSBkZXZpY2UgZmQgc2V0LiBJ
ZiBub3QgYWxsDQo+ID4gPiBvZiB0aGVtIGFyZSBpbmNsdWRlZCwgZmFpbCBpdC4NCj4gPiA+DQo+
ID4NCj4gPiBsb29rcyB0aGlzIGlzIGEgY2xlYW5lciBhcHByb2FjaC4NCj4gPg0KPiA+IGlmIGEg
ZGV2aWNlIGlzIG5vdCBvcGVuZWQgd2Uga25vdyBpdCdzIHNhZmUgdG8gcmVzZXQuDQo+ID4NCj4g
PiBJZiBhIGRldmljZSBpcyBvcGVuZWQgdGhlbiBpdCBtdXN0IGJlIG9wZW5lZCBieSB0aGUgY2Fs
bGluZyBwcm9jZXNzIHRvIGJlDQo+ID4gcmVzZXQuDQo+ID4NCj4gPiBmcm9tIHRoaXMgYW5nbGUg
d2UgZG9uJ3QgbmVlZCB0byBib3RoZXIgd2l0aCBub2lvbW11IHZzLiBpb21tdWZkDQo+ID4gd2hl
biBpb21tdWZkIGlzIG5vdCBhbHdheXMgYXZhaWxhYmxlLg0KPiANCj4gYnR3IHRoZXJlIGlzIG9u
ZSB0aGluZyB0byBiZSBmaXhlZCBpbiB5b3VyIG5leHQgdmVyc2lvbi4NCj4gDQo+IG5vaW9tbXUg
c2hvdWxkbid0IGJlIGVuYWJsZWQgb24gYSBkZXZpY2Ugd2hpY2ggYWx3YXlzIGhhcyBhIGlvbW11
DQo+IGdyb3VwLg0KPiANCj4gV2UgbmVlZCBhIGNoZWNrIG9uIGlvbW11X2dyb3VwIGluIGZvbGxv
d2luZyBwbGFjZToNCj4gDQo+ICsJLyogaW9tbXVmZCA8IDAgbWVhbnMgbm9pb21tdSBtb2RlICov
DQo+ICsJaWYgKGJpbmQuaW9tbXVmZCA8IDApIHsNCj4gKwkJaWYgKCFjYXBhYmxlKENBUF9TWVNf
UkFXSU8pKSB7DQo+ICsJCQlyZXQgPSAtRVBFUk07DQo+ICsJCQlnb3RvIG91dF91bmxvY2s7DQo+
ICsJCX0NCj4gKwkJZGYtPm5vaW9tbXUgPSB0cnVlOw0KDQpZZXMuIGl0IGlzLiBJZiB0aGVyZSBp
cyBpb21tdSBpbiB0aGUgc3lzdGVtLCBub2lvbW11IG1vZGUgaXMgbm90IGF2YWlsYWJsZS4NCkNo
ZWNraW5nIGlvbW11X2dyb3VwIHByZXNlbmNlIGNvdWxkIGRldGVjdCBpdC4g8J+Yig0KDQpSZWdh
cmRzLA0KWWkgTGl1DQoNCg==
