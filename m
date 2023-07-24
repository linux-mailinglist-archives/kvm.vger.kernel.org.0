Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D0475E99E
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 04:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjGXCRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jul 2023 22:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjGXCRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jul 2023 22:17:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4B4E45;
        Sun, 23 Jul 2023 19:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690165013; x=1721701013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V8UsvwDiirBYIe4lO94WK8mx7dbFtsaZ5VdkFZRe+Vc=;
  b=LZO5k43+HXEMe14/KKJ3quEmwHW83l3lu3CA3k7SbyYy/6ZDkjRkNl8G
   pzWsKhXL4rY2ekb804ArXyUVS6Apa3Fbans6lO3PqYUpXVpqzlz7TbX0U
   SlYQZY6dEDM0tQidCY8r16/91XwxhQ5YIRvj9B4vgqlCu9G7pKtprCN/x
   JPvHvzvF9Ok0zMg+imQQzEfBGXqHTvLwWzERobdUW2x321W+Mx5D3CQGU
   FvFQtmxD8AcdKaShjRBdkzUkQRwd/kpm29OzhNGcCizSnxwb/3virQGLj
   ljf+9iuU63tjINKFWqBqpwBfymxXsu2fP7nTWA4wZxuY8qM0rPb1UfHGq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="347614975"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="347614975"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 19:15:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="972093685"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="972093685"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jul 2023 19:15:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 23 Jul 2023 19:15:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 23 Jul 2023 19:15:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sun, 23 Jul 2023 19:15:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sun, 23 Jul 2023 19:15:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcuwrrnbAjbeCBIuLkFI1sKchWsvHVRFmjMJV4rgzei9MYL6pzZCU2N/eF4/5NZR2KTdtVBjF/Aeg+OnVXOUO9dOIJZBt3hUCXI5k3VGfWcb8mz8470SeSKYMuYWo3wDo3pJRqpcL8EQoNChdpZ5bjMbXDHBBJM5BayoShQBAEdkE8EZ5+MnrSwFWQgfW1XjHSXaFloSBRMQa1gnHNPryiPh4v13iICfQMz0QcIsJsAR6I4WTmaWOFms6vm7Ho1DDcwhDuPU2exoUp+aFupLMayb0ITZFTLdkxOio8Z4nApJHwV9kvVB8C/rrLDM6wGR3AOmpXOiy+WqsM5893JOiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8UsvwDiirBYIe4lO94WK8mx7dbFtsaZ5VdkFZRe+Vc=;
 b=iofTt9EjIyEF7CJON3H9qCNDP6tnZwlanpmTawBAdEyZeg7iZ/X0Yg3eTgqNB5aWYmdyQ3V4Evpz36OFULwBgCpekHTmYD7NJTkAl2z0HlvIE9zqdwCjxGoZWJb2hds5tfnWVlz6sOFJCW+36mSeiudZrTGMRvjcD4BOAUF8clAJ+dwGRW11olKUakhGKK0coaR29o7MLJ+X3uissAzyvrpttCdS2aR/ZIo3jQPuPNQUqw5qgEgd3jAuUgg941dwtGJswZ6hlGn9IKCSgc9yVIaFmwGpI7WOutF504o6O2OTGZ57c8oLjpcwv/soFi9ed7qTDuNIrRFZpD8hCfhNMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB8267.namprd11.prod.outlook.com (2603:10b6:303:1e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.23; Mon, 24 Jul
 2023 02:15:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.026; Mon, 24 Jul 2023
 02:15:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Topic: [PATCH v2 1/2] iommu: Prevent RESV_DIRECT devices from blocking
 domains
Thread-Index: AQHZtUNfAivNXia3ZE+yVYj94mwJ4K/DlO/ggADLeYCAA93D4A==
Date:   Mon, 24 Jul 2023 02:15:40 +0000
Message-ID: <BN9PR11MB5276EC2FEEF42A5BE30ABADF8C02A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230713043248.41315-1-baolu.lu@linux.intel.com>
 <20230713043248.41315-2-baolu.lu@linux.intel.com>
 <BN9PR11MB52768040BD1C88E4EB8001878C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZLqf3Q6zlnMi+woU@nvidia.com>
In-Reply-To: <ZLqf3Q6zlnMi+woU@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB8267:EE_
x-ms-office365-filtering-correlation-id: 4d019014-1249-458f-1c5d-08db8bebe0e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BOipUIBEGqx8L9P2i+mrHbjXI/DNNE+lUkvhChisVRlzyh/ODEgCrAia2D7//FO/N+yp4NeFrClqCJpibcPU4Z2XyNT7cDiIzqu776hzdVRG17ES8aFOpX1VIw7pAQ/TQE5qez+43iBQ7vkyEGg1koLh4z1fyXjZGhbNNmDi+GeLwBx0QbPZ95c4rDSSh6p7P5EeAh202UwfIPhb+XWr1W87qqtCKWoJOefJ/YN9bAy/liU4RB5CGrGr2i909ajQjKPjRugr6MaF/G+t/pmJe7f/tZQEc6X54j2PWImy79MkQrC4GLSxbgPwRT15TP+yNPq7j1haQvOgatphIfUC37s+rHGckP3E78kOBy8KrubDW9lw+FboXji1FTOlL3fo/oyr3vduThgicSJPK0nmOFk/Z2TGhJtSHdOC/Ay822CUb9T7atfe5UwkXiLBjbuz0YsG+V8ElH9kCb8YpHudQEloGXKCJ6ipyMwAmXdVfien9ie7sUQRLSErgnIrS0ZSkUuh1Vy/5zvZxY0g5ezN/fXCI1ZTS+LQFkMhpDlo3pk5RUqR/ED45UlLBBVU1LkCCsBsygGNTFp5rXwv1qYLARUzPfDONmsIokG03ypLx1Ar/MqtjTjmGIhbNVtdFe5q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(136003)(366004)(346002)(451199021)(4744005)(2906002)(7416002)(52536014)(66946007)(8936002)(8676002)(66556008)(6916009)(4326008)(122000001)(41300700001)(316002)(66446008)(478600001)(5660300002)(64756008)(66476007)(26005)(6506007)(7696005)(186003)(76116006)(54906003)(71200400001)(83380400001)(33656002)(9686003)(82960400001)(38070700005)(86362001)(38100700002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWVKWnZMaXJNRC9MM0R0WXB3ZWg2NEh2Z0h1Zm5MeHJhODdIMW1CeEprR0Rj?=
 =?utf-8?B?UXBGNGg3NnhHY2dVek1UTy93ZWpsL0I0bVc2SG9vVmVmVVZYd0w0ZzVhbEJL?=
 =?utf-8?B?NitaMDlKTTRieU1kT0N4UTVTMlk3K2U2WFhXMUFkV0gyYmVMS1BpL3RQcUIv?=
 =?utf-8?B?OGJINGFCWVJkRU56STlma00zR0wxLzZNWTBKZWRvQjcxVXN3NmxMa3RVSHQ3?=
 =?utf-8?B?eWxYdVRFVmVvQXNyWHRWOTBLUmthaGxFK0x6MnlDSVJJeGRXanl3b25nbG9p?=
 =?utf-8?B?TytyODBEVlRPUWdpUmxKRVFtbjhlU3I2UXBTanhZVkpKOTJRbXI0VTl0cWpn?=
 =?utf-8?B?dFJQSjlLcFZhWjhJcDR6bTM3RUlwUm1pQnBtdnpNd3JrcUg0WFkzUWE0M3VS?=
 =?utf-8?B?bGY4T2VveFJNcmdESGxJNkQvYU1JVVhpWmMrVjFNQktpK05OYnZxaDJVUUsw?=
 =?utf-8?B?WnZYQk43YW9aUTZQVXptbmJ5bU93RHpYWERFbmVzblkyWmIyTE15ZFFzODN4?=
 =?utf-8?B?WldkNE43VmdzU3NXaTVMcVpZQlJGUHhTU1daNmY5QmI5TVhPaWZLWDIyTDUv?=
 =?utf-8?B?NVdOTml2TVdxK3pTQzNsR0ZjV1RESmNkdFZzVHhZMXZDMTA2bmNZcTZMbm0r?=
 =?utf-8?B?Nm5rOHVUY2JWRWNkQjNSZm1uSGlTa0IweGM5MUd3UWpHMHU1UGxuY2Q4bkhI?=
 =?utf-8?B?K0xLYjV4Q1cyV3BMdnJWLzZic1pEbG42UHBUbVkxaktZdWd0bFVuQjhFTE11?=
 =?utf-8?B?SjhpdHExYlRhblZ3T1cyNWRSZUQvT3M0NlVrcWx2YTZDL0w4eU91cW9zUmcy?=
 =?utf-8?B?b1l6bnBFeWpoTnlneHU1ZEFqRStSblNjZlRFMWRoOE9iVWkxRGkvZzZtNFc0?=
 =?utf-8?B?akVNUldjR0puLzZodVFJK01WNnpGck54d0FEOW1EcXJNeXV5dEY5S1lNYnFt?=
 =?utf-8?B?d0FqZTA2VlEra1hCRmtRcjB1K25RTWNyY2xYNU1rN1FLOHlLSUVxT01ic1k1?=
 =?utf-8?B?M29LdmJMN2k5SlRwWXRWQXc1cm5pZEpwTitTVjg1c21NWUgzTjlob05Wd2ZN?=
 =?utf-8?B?MnZKTzFHN2dDMVFPZ0dyL0lUeXVPYmljcE1JN0dqRHRHWVZtaFpwRWthRDhq?=
 =?utf-8?B?ZHFFdUtTMHFQWld3V09sWXp2amNNSGxNWlQreEMxYkY4WFhjUTFOZGFveW1n?=
 =?utf-8?B?TTJ1R0IwUUdvTFJYVjg1SEhrZnNxWW92UFU5YUdQRFdjZ1JnUWZSVUJLRVZ0?=
 =?utf-8?B?NWZ3MG5TeFFlcnJUdm1zbWdqN1VpTXVHQmEwM3EzZ216THplM0N5YitOa0E5?=
 =?utf-8?B?M1RJRHpyL1ZGbUt1WGJib0gzTHRvSzJIVCtmcVdKZUdXTG9wYXhWbW5BNlFa?=
 =?utf-8?B?Um1CYkJGN1NJYk5BTUFNalZHRXZxdkhqa2tBUnBGNVJBRGw1WGo2NitVRCt3?=
 =?utf-8?B?b0k2VzkwcG9MeUdXUGlPNlpDaFRVK1gvZWxjOVZyS0JGRW9ha0lDdU5SZHZ1?=
 =?utf-8?B?TnFLZzBBV1ZPRzF3MXZpSURPUlZQMXY0OEplYmdIZEtoN0Qyc043cktQYWNE?=
 =?utf-8?B?bWNzY3dSZ1hUUUFOenkyai9CbVhFWlRhMmdjQVRIcGc2a1NjRzdmVVVBU2Uz?=
 =?utf-8?B?OUdpV0UzTFd2enZtaU1ib1h6V0hMMTFib0pVM2MzQnJyU3M0b2o1RlNYclov?=
 =?utf-8?B?WnpicnYrS3hPTUlqRW9zSWExLytuNEtNTFRlOHMzTmNjSU9uN2NKZ1BoSEhR?=
 =?utf-8?B?VjAwTzZVMm1zUzk0NWxCWWlqdmFqcjdMQndwYUJPSUtjdENsRUhNUHg3MWQy?=
 =?utf-8?B?OFUveUY2RnFhTTFmTVZnSDRPcWtFUDhHQ1IrOGEwQW1pTVA2WmgzQndGTTc1?=
 =?utf-8?B?NEtCcVhPbGRUQ0JJcmRHUU1HeE1ELzJCcDBCY2NUb2w4cFF3Q0lRdEFUMzRw?=
 =?utf-8?B?RDYvbDIwaTg1S1c2Y0tMZVV3cGtCMGdBT1NYWjRwcTNtejg0N0dMTGNJMDdm?=
 =?utf-8?B?VW84OC9meDVGbDRuWnFXWmh3ZFJjcG5GaHgxRWtEUnIvTWQwK0llcHNuZDdh?=
 =?utf-8?B?YmFQK0Y5Vm1iNHFUT1JWODFGZUFQSk9VNStWbGR6bEZSSWlWRFNmNkw1N1VG?=
 =?utf-8?Q?PHZcERlxR5KWEl91ZkgBpxU1c?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d019014-1249-458f-1c5d-08db8bebe0e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 02:15:40.9012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrET3BupsglFTDNW5Ba4dSe9jveevyzeIQprnqIJeZ8yAOzS6joNv50ZxP4LsOnVv4nHjldGM4j7aPLu7qBxeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8267
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBGcmlkYXks
IEp1bHkgMjEsIDIwMjMgMTE6MTAgUE0NCj4gDQo+IE9uIEZyaSwgSnVsIDIxLCAyMDIzIGF0IDAz
OjA3OjQ3QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gQEAgLTk3NCwxMyArOTcy
LDE3IEBAIHN0YXRpYyBpbnQNCj4gPiA+IGlvbW11X2NyZWF0ZV9kZXZpY2VfZGlyZWN0X21hcHBp
bmdzKHN0cnVjdCBpb21tdV9kb21haW4gKmRvbWFpbiwNCj4gPiA+ICAJCWRtYV9hZGRyX3Qgc3Rh
cnQsIGVuZCwgYWRkcjsNCj4gPiA+ICAJCXNpemVfdCBtYXBfc2l6ZSA9IDA7DQo+ID4gPg0KPiA+
ID4gKwkJaWYgKGVudHJ5LT50eXBlID09IElPTU1VX1JFU1ZfRElSRUNUKQ0KPiA+ID4gKwkJCWRl
di0+aW9tbXUtPnJlcXVpcmVzX2RpcmVjdCA9IDE7DQo+ID4gPiArDQo+ID4gPiArCQlpZiAoKGVu
dHJ5LT50eXBlICE9IElPTU1VX1JFU1ZfRElSRUNUICYmDQo+ID4gPiArCQkgICAgIGVudHJ5LT50
eXBlICE9IElPTU1VX1JFU1ZfRElSRUNUX1JFTEFYQUJMRSkgfHwNCj4gPiA+ICsJCSAgICAhaW9t
bXVfaXNfZG1hX2RvbWFpbihkb21haW4pKQ0KPiA+ID4gKwkJCWNvbnRpbnVlOw0KPiA+DQo+ID4g
cGlnZ3liYWNraW5nIGEgZGV2aWNlIGF0dHJpYnV0ZSBkZXRlY3Rpb24gaW4gYSBmdW5jdGlvbiB3
aGljaCB0cmllcyB0bw0KPiA+IHBvcHVsYXRlIGRvbWFpbiBtYXBwaW5ncyBpcyBhIGJpdCBjb25m
dXNpbmcuDQo+IA0KPiBJdCBpcywgYnV0IHRvIGRvIG90aGVyd2lzZSB3ZSdkIHdhbnQgdG8gaGF2
ZSB0aGUgY2FsbGVyIG9idGFpbiB0aGUNCj4gcmVzZXJ2ZWQgcmVnaW9ucyBsaXN0IGFuZCBpdGVy
YXRlIGl0IHR3aWNlLiBOb3Qgc3VyZSBpdCBpcyB3b3J0aCB0aGUNCj4gdHJvdWJsZSByaWdodCBu
b3cuDQo+IA0KDQpOb3QgYSBzdHJvbmcgb3BpbmlvbiBidXQgSXQncyBhIHNsb3cgcGF0aCBhbmQg
cmVhZGFiaWxpdHkgaXMgbW9yZQ0KcHJlZmVyYWJsZSB0byBtZS4g8J+Yig0K
