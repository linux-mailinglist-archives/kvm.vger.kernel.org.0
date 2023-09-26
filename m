Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41627AE45C
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 06:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjIZEBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 00:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjIZEBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 00:01:18 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5293CFC
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 21:01:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7ebS6/UihS/faq8TUrpkTTdRnEmTi5ptCk4cqnTdnIy0DO4mDk/Hl8KPUJ5ONVOOLpu+C72b6O+OparthBNoV3aH20wK47y5ooXCYpybCZDGvEI5yw7sbLgfsBoLC2iYAQON8ZBW3TGeLi4tC7lE6awIBgJ6Kyo/tmez+D6Wvwe9aeEgZ/oVS0Bdqub6FrQ7dWvbqdBF8tOzmDK2LQUC78vZMFkY6PzGC74YuW8QN0IWzHc7yHWwKgeP1toBJxmGDap8CIQ+pLI/ckg8qnc32YwxKq5WC3JIVeVt/oHkYQhORW/7iWPKh4B9FVwkgceR3CCBlPYkhUMxzr33Oer1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9qdFRRbBUZDx3nSl+45qEaemNQToXxbAFToFabLrV0=;
 b=Kdc3Xb8isPSkMShoYNDMMRfmFB2XSvm8HT56TGF0Rjdt62dJOZgvC6ROB1hmAaaZa9Fgo4TsOLVXahlilv75QbRIGcyLpfz3RlZnKqJUPEDoVG40e0WTC4VWTjpa9yy3dySVDuvYzawy516mA0nKHa5DcsejubD51YF9BEMCp4AdlBKWmn9G0OWYGb1KYNQ/QC7Ra58QyAuGjRHAwazwFJlq55g6Ao9AYwSajIcP/ZwKNAZGoTJudsuGmoW02ff+BY7kkTSX5t10Q2opx0BpIu1xhsNE2O01gAxNsLNIuekbZ/fOZpd/VJa6U5B1xlDKaWOaynmbcONFFEtT0+Y2JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9qdFRRbBUZDx3nSl+45qEaemNQToXxbAFToFabLrV0=;
 b=lTzb5ytjeS1Wcyeg2Nv12Ziw9Xsy6uxS9d5rKjMhbKtXeDk3e69x7+a6GB18jPqLeEfi9TEXFnREXq7PXuCwjlF322Lx7adseAzmJESl963EhjvLaHo9yTNLEfXrxSxm3z24//7Dtn+TX0tjYGE8Adk7XjDhcwXCi4g9iypVJJ4LE59eStE956DfFShVZ8Y9Awm2hHe3EJ4aoLKuw+Df50VgmkzBK5xVxKlPfMu5hsrNbNKYX31WWl40bR7a0Xb4It57HWFMX0Du27+RMthMR+IhKuzHrQrr0+6fb1Xb77xSLr6oxGsTwmb+StjPONawBH/ZEGmYlUguTcavt8bzsQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CYYPR12MB8924.namprd12.prod.outlook.com (2603:10b6:930:bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Tue, 26 Sep
 2023 04:01:08 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199%7]) with mapi id 15.20.6813.017; Tue, 26 Sep 2023
 04:01:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
Thread-Index: AQHZ7IkPl5ENqOgMC0yEzkOHANq/CLAlfIYAgAACZQCAAAJ1AIAAAaqAgAAD/QCAAAaKAIAAAwkAgAAF2ICAABWjgIAABYGAgAAGVYCAAHFrgIAAnJQAgAAAJ7CABBFQgIAAYeqAgAExEoCAABiE4A==
Date:   Tue, 26 Sep 2023 04:01:08 +0000
Message-ID: <PH0PR12MB5481304AA75B517A327C5690DCC3A@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEv9_+6sYp1JZpCZr19csg0jO-jLVhuygWqm+s9mWr3Lew@mail.gmail.com>
In-Reply-To: <CACGkMEv9_+6sYp1JZpCZr19csg0jO-jLVhuygWqm+s9mWr3Lew@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CYYPR12MB8924:EE_
x-ms-office365-filtering-correlation-id: a8e17382-7a6d-4edb-1c62-08dbbe4536c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2J929Y3qKkrHTLJr67qxdCt4oRrHb0pXhFod+hcblu0bcuu85aH6ll/X8gH9lCB0yf+mTePMtDq6ck7T+SOhHBbUrS4b72h1IsictOx3B4eCOCAbJLMxtkweOgomPoTMws8dvdZIeDrkbPKrSVzGp9lV26JxcepCcS0halh+cx/tLlS28hYXejKFlY0Q2s3EctOfZGv/KyrT0Rm9w4ACUT2KS7KVoMjT93FjNrmmgfMed3baSYZrAz8NY1v7ibb3bxHBk42svqqsLtFviRvgvUHcEH0NdHVhn0BB7WjD5MYs8m3+7F+MuxYT65YcR2K0zF7VehcTZo8Uj9Rw0ylSuapeJqtVR6UqFbyKIqyl+e/y31pJ6kTKfRuE2QbVbJf/KYN12HGHIqV7Zyz3IyVqZGDtCl6BUitjU/y0yFuQOaO5UdzDFVSpUHYSr6Ks64Kb6O5EE3s8KpyMcwfxyRNaRIV0fMXAGMMwQa3G1sQXp5w/TqI9nwh0Eqr2ZySKmfQr57Sm/ch6xVTx8GX+Svbust/tHl4r3k5bjsfVqMVSL40X04yOmJcV5GUF15UtJaS16xxaMa0lS/LPZ0ud3Xqc7iY2jFe8wipfaBtlfTiYgIVZCxjBOPcURZYVJx5+1ob8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(366004)(39860400002)(346002)(230922051799003)(1800799009)(186009)(451199024)(26005)(122000001)(71200400001)(478600001)(107886003)(86362001)(38070700005)(55016003)(33656002)(558084003)(5660300002)(55236004)(7696005)(38100700002)(6506007)(9686003)(2906002)(8676002)(4326008)(41300700001)(316002)(54906003)(6916009)(76116006)(66446008)(66476007)(66556008)(66946007)(64756008)(8936002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkV4czVRcjN4SThHMnNPdENpQUxWZEsyakxkYzFrbUo3Nzl1bXpkNG8yaDBY?=
 =?utf-8?B?L29QRDBiRW93RGRYeFBPNk9JczdFa1J5SUJma2REbGtVd3ozNFU4MVpNMlhH?=
 =?utf-8?B?R0c2UjBmenk2TXVkR2NVUkV6bWRPd3RRYmZiWlRxT25PbTJpQzNjMms5MTlm?=
 =?utf-8?B?NWpabzdvQnhiTFkvQWExY1N3aVNyZDVxV0pheER3dkJsM3RpVkZJRnlmWkFz?=
 =?utf-8?B?UDBMUTdycGQ5eVEyMEMxQUk1M0h0SkU1MlhpTUxXMWZ6bHlBSkVDaHl1Wjl4?=
 =?utf-8?B?QWhwR3VYalBVc01RbCswaFZ5SUppOU4xci80a0JVR3N6SUNSMFhrRDNCb1JB?=
 =?utf-8?B?WnVMaHhVNlYwYTVsMUI0Y1VPSnlNcUswOHkxSmg0aGZDbjVxTFcxQzJQU0Rm?=
 =?utf-8?B?OFJIMmZ1ejZrWDJnTjAzM2VXS25uL0ZMdkQ5TkszQWJJRS9uN3RlWDRvUVhx?=
 =?utf-8?B?eGwyV2lKQjVJVDBrZ253VTRZN2txeWxKemUwN3FvZ1N1MmwyWUlDRVhHUys5?=
 =?utf-8?B?aTMwTkU4ZC9hRDNrU0RDeGxKWlM4NFFjUHFrYzVJajR4OGVpUGlodzdlbmRV?=
 =?utf-8?B?ZGxqbUlMQjJuLzErNnJrb0JkQ2d3RkJIUDZ4QlVhcDRLdDBTWi91N0IxZGIz?=
 =?utf-8?B?Rmdva1liZHlMa3BsdWFjQ2xaY2NhV2I2Qi9YL3NkOGVVSFljMHJmS1Fad1RV?=
 =?utf-8?B?eDNKMm1zei9pOEJEM0tXeWhWWWlHTEJxRUZhaEk2OHdTSy9xU2NSTFlaajd0?=
 =?utf-8?B?NFBXQ0xETFNXZUV0T1pmU1RJZDdWaEsxSzJ1VHpKd1VGcmZsRnUwM3ZUTDR5?=
 =?utf-8?B?NU5YMDZxU20xZVh0UjV3UVJRODJGd2RrcGkrWHpYajBKQUZDdENmMnJ3ajdl?=
 =?utf-8?B?UnNobmhNL2RJbk5oZWowOWdlMmtwZDBLKzBtZDVNbU85dE1sTkx1UmtEbWox?=
 =?utf-8?B?MTI4akhXL2FTRU9RZWFvWFZZMjJXdVF4KzVILzhiblUybnM3MUVSN0xKaWJF?=
 =?utf-8?B?ak93REdOMko3d1VRRFZDemgvQTFPUnhtSEdycEY0YS80ZlhEOU41QTlVcHNi?=
 =?utf-8?B?blYyUUR2QzBTZUJETVdWNkN3VGE1L1lQY2tFcWxKTmdnTWNxbStqbndMVVJB?=
 =?utf-8?B?YW5HS0ZyaDY2azZuS25XYmRCUzZoa1pmOWNXLzF5UFFwQW9aMExkdUxyUS9P?=
 =?utf-8?B?WkhqOG8rL1JQSTUwM2c2dTY3VkxkQldXVDloZDNncllnb1BDcVk3RnFOelcv?=
 =?utf-8?B?ZFNLWUxwRWhVMkloVFVPeHN3ejdJSkJXNnpTUnhDV3FQYUpFUjcvZ1MrQXc2?=
 =?utf-8?B?OThhREE3TGFkVmlCNkM0cmFLRmQzWWxORGx3dlJLdEFhMElIbzdxeE1RL3ha?=
 =?utf-8?B?VXdkVklVVGJ4WnNFd3ZrTk51UFJsTTludGJIV0pKWC9icEd4RkFOTklBRy9I?=
 =?utf-8?B?VnNuYVJONlN6b0h6b0p3ZGRlYURrTTJQdm1YalZ6c0tFK0RSRFQyTEZ6WnZR?=
 =?utf-8?B?T1pKdUJXSEZzR1NFaldoUGEzdkFpdnhNUGlEUEl6S3MwRm1ZSEhyRTZRUm8r?=
 =?utf-8?B?TjZyUmJmN0xQUHFLZStoUTVWVTAwZFJKTnRmTW1uQVd2NnRoRGNXeVY2dDZM?=
 =?utf-8?B?dmpiT01DcUx6ZHFJZkZ2WEIveUFoalI2UkFjQ3RGL0phaEJNTDIzTFNNQkt3?=
 =?utf-8?B?VnhoYzN6NUVCcHhaam1QQmtCcnBNb0l5YmxTaGFuZGNSUU40dVhMZnNGajZ4?=
 =?utf-8?B?VzdPMTl3VmpkSXBTQmhZWHh6U1dVR1MyTGk0UVp3dmR1S2VFdDNwVXhZZmtp?=
 =?utf-8?B?MVZJYXk5cjZTcVpuakhJZ3U0aUx5OU9NOWRmUUQyWXplL1BHY0dFbzlGYzZ0?=
 =?utf-8?B?UStaR0lrV1lRY0hIY1FzakZYTEFzdFNSMmc1c3NYOXpIMzliVE1lM3AzNlBs?=
 =?utf-8?B?MDhPeGlWZUF3S1k2blhRMzlBcnZrSHc1UjFsT0lSMTkyWklPbjI0U1Y4YmtD?=
 =?utf-8?B?MUcyVm12b1RkSDJuVVlZWVk5QWJmYjhSUWRJYWVPS0NWU2FMWmpCZUNiV2FQ?=
 =?utf-8?B?M2dkQVQ2eWFNNDVjQ3NQVE4zY1VTTzZNanBsQUZqdm5heExPQ3lCaUNmVjQ5?=
 =?utf-8?Q?Wun8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e17382-7a6d-4edb-1c62-08dbbe4536c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2023 04:01:08.3844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sCq0WpYMV1W3W29Zt2UYvR/P96jCXgnzubKEyuhLtgWHmlQIzAgCnTRg+M0weBuI8PSkQz3KwYBW5X4LKsVyhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8924
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogVHVl
c2RheSwgU2VwdGVtYmVyIDI2LCAyMDIzIDg6MDMgQU0NCj4gDQo+IEl0J3MgdGhlIGltcGxlbWVu
dGF0aW9uIGRldGFpbHMgaW4gbGVnYWN5LiBUaGUgZGV2aWNlIG5lZWRzIHRvIG1ha2Ugc3VyZSAo
cmVzZXQpDQo+IHRoZSBkcml2ZXIgY2FuIHdvcmsgKGlzIGRvbmUgYmVmb3JlIGdldF9zdGF0dXMg
cmV0dXJuKS4NCkl0IGlzIHBhcnQgb2YgdGhlIDAuOS41IGFuZCAxLnggc3BlY2lmaWNhdGlvbiBh
cyBJIHF1b3RlZCB0aG9zZSB0ZXh0IGFib3ZlLg0K
