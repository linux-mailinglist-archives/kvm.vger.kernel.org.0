Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23267AE443
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 05:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjIZDpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 23:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjIZDpu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 23:45:50 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517BBD7
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 20:45:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFnr2zY+LOjFQ1LfIOnjUqEpGvlm7Dkm9VwOCHU+5Wt7IfvjBiQ5XSWfRI2As/qwj6xK681rDVuYS6hcAocHpM1p8DAdy6PXc0uHNfNjQ50vzKSNxHhWmK8ARhGmtVWnYTSbdbWLBzwnrH3viJWuoCD/k0zsaGY2pjzeemZwGIu0zgLMKRIEndpMCLcQn0X/wYQWaAIP7KOseZn9eUxSeigkUIxVTsGNYAirB+DZ25i0gPMMLrZjJyfzbNxAzpVTCk8Un1k2Gx294P4ttFwMcQ56B5lqDwyTbucaAjIiaahOkOC4cUXTwbnnkYpm87oaHiuq+3IyzneXT47bELC7nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8ieXpLBMY58OGLCCji12eyBvHZXz5gcdk2pRc1O5EY=;
 b=obkZnDtIS10eSuL0PHGCphuXSBrbttODyEUdPFb/fTVUK+8Q568tRBh6L6g04U5T2+l9IkdZKfbZupSdixCenozRM7kL5pUjcISQQ2W0zOC/HPtIQRcdoRrWTlIvCz0h3QDX2Py33Naz2dzMTgkRd81R1wWqH0PPgJeFHIUN7HOs6Hh6XYiIBCJdcVvehRb8kgJKQQwjiB7qSfTMzW/6L7Lb3cXlR/vgvrKWgUuayFHeCLQemmGAFJj1BUFcl4WSCK+SB3zcit+2u/R1zrO8SdKNBzTWVsIflFKSQIM7amjLMCeruZPDd1vWKcUbq9a1Lk56wevhtSrJ6+jEmsSchQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8ieXpLBMY58OGLCCji12eyBvHZXz5gcdk2pRc1O5EY=;
 b=L0vvYNTZCHp6QCPlW3gCN+6xBgBtIRh4o0eJzh6BZ79IuhHROOodIETJbAkwoGxNyRwDl5joaDAlsZ9jLdw8v5AH8XTa2xyTgFUbmX/ntYdPdbhc+ER9NsqMcqexzxhVN0PoJIaMTffvAKuiY6IMdjgaVuNhPQP5HTqjRFcj0oIXvN888sg2upnjBeV9u5heGj5QmoiOIitKMTJToGIjZHjWSnfgtSOTzZysdd4Wd+1R3Ryc2RH+dvonzr97TZp8AMPrxNVhiBsCMJjfRkzUbICES8NtNZIu6EHqeTNkqX6icZ21/rrr1SBTAsM3zRWlHNC24q5tH1QARl55R0VJsg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by LV3PR12MB9165.namprd12.prod.outlook.com (2603:10b6:408:19f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 03:45:37 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199%7]) with mapi id 15.20.6813.017; Tue, 26 Sep 2023
 03:45:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHZ7IkPl5ENqOgMC0yEzkOHANq/CLAlfIYAgAACZQCAAAJ1AIAAAaqAgAAD/QCAAAaKAIAAAwkAgAAF2ICAABWjgIAABYGAgAAGVYCAAHFrgIAAnJQAgAAAJ7CABBFQgIAAYeqAgACr64CAAJhp4A==
Date:   Tue, 26 Sep 2023 03:45:36 +0000
Message-ID: <PH0PR12MB5481AF4B2F61E96794D7ABC7DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230925141713-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230925141713-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|LV3PR12MB9165:EE_
x-ms-office365-filtering-correlation-id: 0c9c9134-d381-4203-1456-08dbbe430b93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lr+IFZ5YZSx/M2/bDsByHcH7GgMJGIhZqLkiJkifZiqh9cYND4CMZkLIclXZhK2ACTHVxnRIqbP7A5nKzbMOAYQUnc+0ETbdjVpjvjoqYKZasTBJdUwg2i/p3NzHGnrtWNq3cV6ifCiubT4zRUg60ajAssoPmdJweQf4rQu6WWGbK1/wAXbvePEjx0Drvd5y3//K8OMyqPWey1VlNZOLEymuA3Bu7PaaW0MbrTbXRx2ezWkbm7fquH1YghLdNoBSXIwZ3aG/KXA7PsNVsEco4JI5Dl5QsT8u0p309+y1Z7R42yjKC4DqDMio8tobyWSKELV5DJ+e8AOnnHnmLSNDkeMt8XHBW7+4bi7MBshF6xAsotOKJekBJpubeElRVQuAQG3658psBYZqWEYeDP51rYuC3Nvy6HkFUjqAndpzn7m8OnLqAJB8+uF4kOTm4TdwfHMj+ka64urvRgMg3yLQeM9T1eYiz6//aPHF++3Ir17/yFJNipDttiIuafm/0zEeub6CFXpHRnbJ0cfItkVJrNI15FPwDwEw8MiQD3rPemIRhOnqTbY4L0mZcxEwEpl5Kqni4i5hXtL5PEDasMLrQ0n7vuLix3Q3XL9FYDPtaKDh+UtlB9XKfBpt/LSXpiL7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(39860400002)(346002)(136003)(230922051799003)(186009)(1800799009)(451199024)(55016003)(2906002)(38070700005)(83380400001)(38100700002)(4744005)(122000001)(55236004)(9686003)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(76116006)(71200400001)(6506007)(52536014)(26005)(5660300002)(316002)(41300700001)(6916009)(478600001)(7696005)(8936002)(8676002)(4326008)(107886003)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDFGVFh2Qzl3U0NrakNuYUFlR2RjUnU5ajN3eGZRbFVzdEdiV2ZBOWZqaWFH?=
 =?utf-8?B?aVE4OWF0bG8yUit4Y1ZaTUhyek52Y1VDU1o0alJvd2VnNnYyOVg3dUN0M3hR?=
 =?utf-8?B?VitSYUZIeGt2VjhmSFpJbHJmdjZIdTduQVpvbmExcmh3SlpjanpEREtSdXJK?=
 =?utf-8?B?RXFZK2k2V0NEY24vdHN0U1lKZGt1aXFUZk9tdTNXcjExc1JEanhlTlQ1U25K?=
 =?utf-8?B?Q1NEMXhjWWVvd3FKUzR5MTJzamRBbHN0SXpRZEhwckNheEhaWjE4UGEzYVlK?=
 =?utf-8?B?bG1heDRCMGQrdkQvcEduQmNJQ2diR0E4TE5lUFB1Z0JrQXZIUkRqVlYvQ2Yr?=
 =?utf-8?B?RHZOdGlYTi9VYmlLSlM3Mk1YRlpaMGU2SEFIbW1ENHNyM0dEdEdjY0ptNWgw?=
 =?utf-8?B?Q3VEOWhvT1R6QlJETkU5ZFVTWGRGc0F3V3FPYXhNRC9FUEtSSXU1WkFSZEVI?=
 =?utf-8?B?UElCaTZYSzg0eTNTNnIyTVRpS2NjckQ3am1Fa080WmNoZnlWUm1HUmV4VzFQ?=
 =?utf-8?B?aVVWcmpGTm10UmFuWWJLZHNKYU1oZE02WndpdTBGY0tZQmRza09sNkVCSWJa?=
 =?utf-8?B?MmdEK0k1bUJ3QUl5NnZwMWoyTWd6RmxNMURZcUEva0tZUTBQQUxJV1VINHd2?=
 =?utf-8?B?NnFTV0hVZWdvdGpwRk1YaVhyc3FscXc0dm93ZG9HMWRxTnJyMHZVM1ByK0hw?=
 =?utf-8?B?WkliTDNmU3RPV3Uycm5sOWIyTHNLWDJncCthUUVrNmhtQi9qMnpPTUhyTzIz?=
 =?utf-8?B?YXZHY1pEM0R5L1BEUUsreDZlQ09LRDdOM0Mwcld2UXV3blpRQ2F2TE9OMnRZ?=
 =?utf-8?B?SUNucENkMi93eEZIbDFLWDJNVlBDOFB6Z04zSkcyREwyNjJkbGxPaGZWcm9E?=
 =?utf-8?B?OUgvdjZTSEUyVVRKQjJReHRZOHVSZzNJZkh5Q2VDOUkvNlBKd0dpSVFnU2t4?=
 =?utf-8?B?L1o2UWEwV0NBYWh4VlBRK004dnIxTlcycE9FTVNzb1hiSDdJcUx5enhyZ0o1?=
 =?utf-8?B?VmdoMjBJSlFHVjY0TVArVnNBZGRKSlZyTld6YnR2eHMwektsNzduZ1NJWW5Z?=
 =?utf-8?B?YzRBcGZ2ZTA3d25MWTQ1dEsxcGZ0RjBHMVQ2NnBPQVVRV3NNMndXaDFYMXpU?=
 =?utf-8?B?aUwyT0c4SWt2RndjVXBTRE9IdEwwS3VobGFhU3M0b2djOWJWeFRFUktla082?=
 =?utf-8?B?ZEdsTEI3STE5OURBRW1yWWpSRTBsZkVYRDdnOUNnWGd5ZkN0a0NZZndwcUZF?=
 =?utf-8?B?YVVVQkZWMnVkaEdLbktzUTZlWk9kQlBVT0ZmTG5oeU5ZMGJrazU2UFV6Zzhu?=
 =?utf-8?B?MXhsY1JkMG1wZktNanhPaVlMTnV6TEU1RGdVRk1pT252QkV1bGp4WHcrVm5t?=
 =?utf-8?B?VU5vREtzMHpmTkxBZllVY2lINXBKQjRScGx6YW93RUZsaTlrUWpWRzQvdGNF?=
 =?utf-8?B?cGFZazBibkcrbmhyNU1wQnNBREVQaDN5WWRvZjd2aVE0L0FoU1Z5WFNqZ3pB?=
 =?utf-8?B?ekRyTllZb21sdGU5VzZ1RDhaa0s5UmxONFY0dU0zTnFJN002ZDhIMjVoMXdH?=
 =?utf-8?B?bDRXaEd3MFNmSVlra3FGcE9OM0lyT0xIcmRGY1I2L2IrVm1tVE5QVEhRbFFm?=
 =?utf-8?B?S21XK2ZsRWNqWGM5dW9McUVhYnFmYjNqcnRzVEdVNlQ4MU9OMHV4RDJxT3d6?=
 =?utf-8?B?U0gyZExOU2RHK0VuTEt6OGJXejY4Nmx0cjI5LzI0WDlzVXI4RkFRZWNvVWRp?=
 =?utf-8?B?eVVSMGVzT0FtS3hTSzhWa3FDTmlQNjhNZ2xkMWlYT0dyS0toamVoeU5lZWtT?=
 =?utf-8?B?cStCQlRTNHorK3JTbGx0MVpZUCt5TmpmMmJJUDdDRjg3VmZTV3IvcUp3dlB1?=
 =?utf-8?B?enFoWVdYc3BrNTBkanN2RWRzYVZWZ1lBQTlIN3duNmZFUm5yVmIyVENQQnRE?=
 =?utf-8?B?V0ZGUnI5ZFNEUmgyTFpoaTlaTGNQWkw0NW9YZEh0WWwrZnAwekhjZnB2YWw0?=
 =?utf-8?B?aEQwTUQ3dkV1R3NpaENwNUZZU2JMdXkrMk9rYkpMdFNwNmFMQ3RmcC9mckNt?=
 =?utf-8?B?aUY0dzg3RS81eGxjK2RSS05OOW91aHZ5RlhOZ3NDcmNhZFRwUXdmZVZEL050?=
 =?utf-8?Q?Dymo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9c9134-d381-4203-1456-08dbbe430b93
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2023 03:45:36.9006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lEBKLBjrFsfbRz23W8XUw+B3O0eYHsM7BjZzEBbRC+uh3ER82Eowt+z2lP67ahDT4J/PL6UCzQmWi1EgM+mMmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9165
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gRnJvbTogTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT4NCj4gU2VudDog
VHVlc2RheSwgU2VwdGVtYmVyIDI2LCAyMDIzIDEyOjA2IEFNDQoNCj4gT25lIGNhbiB0aGlua2Fi
bHkgZG8gdGhhdCB3YWl0IGluIGhhcmR3YXJlLCB0aG91Z2guIEp1c3QgZGVmZXIgY29tcGxldGlv
biB1bnRpbA0KPiByZWFkIGlzIGRvbmUuDQo+DQpPbmNlIE9BU0lTIGRvZXMgc3VjaCBuZXcgaW50
ZXJmYWNlIGFuZCBpZiBzb21lIGh3IHZlbmRvciBfYWN0dWFsbHlfIHdhbnRzIHRvIGRvIHN1Y2gg
Y29tcGxleCBodywgbWF5IGJlIHZmaW8gZHJpdmVyIGNhbiBhZG9wdCB0byBpdC4NCldoZW4gd2Ug
d29ya2VkIHdpdGggeW91LCB3ZSBkaXNjdXNzZWQgdGhhdCB0aGVyZSBzdWNoIGh3IGRvZXMgbm90
IGhhdmUgZW5vdWdoIHJldHVybnMgYW5kIGhlbmNlIHRlY2huaWNhbCBjb21taXR0ZWUgY2hvb3Nl
IHRvIHByb2NlZWQgd2l0aCBhZG1pbiBjb21tYW5kcy4NCkkgd2lsbCBza2lwIHJlLWRpc2N1c3Np
bmcgYWxsIG92ZXIgaXQgYWdhaW4gaGVyZS4NCg0KVGhlIGN1cnJlbnQgdmlydG8gc3BlYyBpcyBk
ZWxpdmVyaW5nIHRoZSBiZXN0IHRyYWRlLW9mZnMgb2YgZnVuY3Rpb25hbGl0eSwgcGVyZm9ybWFu
Y2UgYW5kIGxpZ2h0IHdlaWdodCBpbXBsZW1lbnRhdGlvbiB3aXRoIGZ1dHVyZSBmb3J3YXJkIHBh
dGggdG93YXJkcyBtb3JlIGZlYXR1cmVzIGFzIEphc29uIGV4cGxhaW5lZCBzdWNoIGFzIG1pZ3Jh
dGlvbi4NCkFsbCB3aXRoIG5lYXIgemVybyBkcml2ZXIsIHFlbXUgYW5kIHN3IGludm9sdmVtZW50
IGZvciByYXBpZGx5IGdyb3dpbmcgZmVhdHVyZSBzZXQuLi4NCg==
