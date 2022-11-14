Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68746627A71
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 11:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbiKNK3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 05:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbiKNK3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 05:29:20 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A4BE007
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 02:29:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1R/o/gpJbFYCVOWgDFQ9HVnBeNH7ANfigtXosGaCXxovmYz3cx/xLo+mn968mEu7anmHac074mFQJKwu90tqFP5xyBkzKYsm+U+13s5n/G8snrgBam/KBEXr70wP0KsJIU8KwG6VIrUqE/+UNa9OxZ4qe4dV0sFxkEyV8rJS03JA/kcbXkh8uEpOoYEawo3VlFByc/5yapLXW3M8teN2iUklerMDKO3I/BKqVfpfxXHvGcvGas4RD6YRTxRRVYGDY763UbfkudOF/y6GOXGEY52J1cLjDl74jHR3FiIfniKkHn5D07AoNwXQRGnQlyJgtHYrBb6sJT6rSBolJ/mQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9ekEha1qt96erpI8a9sxHRxJNsXezXeajA5+rOySgY=;
 b=eFAPneECdmp96zL46wW9/wzZdyWLWTfpjF2e+4gDDmeESHeC0Wm4APbOCugueRKsBwK+E2wgEGzh3Zu70/OhJ1g2CTzJo0aiMNJYDz5Y3dRYdH9ji1IRqtVLeToahwjcY2EdfKIDzAqB5PU93trqm2E0jY90ft41TeRwUHh38QNuUTlCL8DP/O5zX12xoMdVhDbuhNIR0IFBDPtThENXRro104NwqBArdxRytQAmFuQQrC2zmaq1fO3dWqg0euJPpTnQ7AowedDl81H7w9mKtvW3RNGBkFvXNTKHkb07vkbDy1RI4gaySrZwHxD2Fbu8zfzQj2Kly9bQxKcOE95yew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9ekEha1qt96erpI8a9sxHRxJNsXezXeajA5+rOySgY=;
 b=3TfrbzQV/YFW07aHJVJONNyr5r4AYDIzKsYe7sEkkvwLFdGDs96ZHMT/y+P4Qw7BOl+gBdhPKuShTaJcbzesoGl5qWb1YuYlK/bi51/F+zn8hjmhmLNgXYgXlzOFCmqflbOV6sHLW5sCocqIWBgXjJbx6Ghv6eL81YCfi5H+48s=
Received: from DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12)
 by SJ0PR12MB6735.namprd12.prod.outlook.com (2603:10b6:a03:479::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 10:29:14 +0000
Received: from DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4838:942a:8267:5ec0]) by DM6PR12MB3082.namprd12.prod.outlook.com
 ([fe80::4838:942a:8267:5ec0%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 10:29:14 +0000
From:   "Gupta, Nipun" <Nipun.Gupta@amd.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>
Subject: IRQ affinity from VFIO API interface
Thread-Topic: IRQ affinity from VFIO API interface
Thread-Index: Adj4E4QdRzmK2kWOR2ytM0xkrT5X3g==
Date:   Mon, 14 Nov 2022 10:29:14 +0000
Message-ID: <DM6PR12MB3082B79FA197958F10F61205E8059@DM6PR12MB3082.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-11-14T10:29:11Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=74e43683-5916-44aa-9b86-a61bd5256733;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3082:EE_|SJ0PR12MB6735:EE_
x-ms-office365-filtering-correlation-id: 913b46b8-ddc9-4ed9-27e7-08dac62b13d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7LfWRkMa2JddtZf8k3p1qMDOp/VNrnVu40IwH0nmXQu7TMZMYmHQGMYW2m2K8NLR5VQedDtVoNdtJkIX8ozmUgq0Wb/SpXeQVXTIRN1XNf0cLddzi9vC2txgBQSeppHYfph5LrwLXWDxopqCJpCN6h6mmYQcVyA65VscCBBs4L9l6zIxc98lfVA0mq2x60hzXWLfJs1TfMKvBLtKifh6+55/SlWx6IQv4joGPwYQaVLETkgXp23UjOqT7HMYtQ51pWfLUw+GR+aRBCZm+dkZiNUVVUxtF3+t4fgU7lSo+EhESERXBMVhDDp2EE4sW+nd/OS4rOBgFJJWjrwpK3mQy4gS7tc2nMfesXoCrd3UHbZVZWj2fsfOjtJekv/8LZEYLlRjz4wO0myfa+/B+bcOXyK2dUgN8Xx8nYX1IDSAuaYvTsHzITyBxenJZt+VfyultjpcP2I7FnLEDx2OEvNIbhH1/DJl1buYAalFXMh1PkHLVKclmURJ9uEYQC2OBCXvF0DvcCBjPqcZHGT1y+6tuS8ldDyi/SKSNDFWFenj843/9uStfrnKLk17rPU2OEf+oaKqvJMm+q+n/HWWWiiKjjuwRB3dBZAWjIj4SiV7qK+hawsAnBAqpbUefu7RmPSrBWSYUEvn1uGUkXydRWOoXPScR4R8EZ8rwI9s3iVTe3UPt/dbJ3uufSpwLJmfgIw24chftlX5zQgOFH0Fqyt2pGhILXpllACoxgDd7c7dWMQPhqZCp7QIdhUvogAOwf8XJNK6q1MZ8qxfFyAksTIwrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3082.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(83380400001)(186003)(38100700002)(38070700005)(122000001)(2906002)(8936002)(52536014)(4744005)(55016003)(478600001)(26005)(6506007)(7696005)(9686003)(71200400001)(8676002)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(4326008)(41300700001)(5660300002)(316002)(54906003)(110136005)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lZJNYlthMuXlyCxeN6jjbSEDPCsPGKW/YCbs/fweknJGuHe02ihXp3XQNhC8?=
 =?us-ascii?Q?CA1QOJF9sRRKIa/fW0O+7xyTi0hIiy/O/cnlzIoYGUxDQYn0XbdSQRErgXzP?=
 =?us-ascii?Q?cALPNzYjYruPGrKkVoE+Z52DxdyjPuHom5Lg/OXYdo4/gOrW9+wJDSZNmLZm?=
 =?us-ascii?Q?fQ6ulAmmu5rDM9Z9ubZGY/snNrtzGcCsV8u8xg+xZoGT8kmsK3McIBrASXsn?=
 =?us-ascii?Q?E92UMMvJfzfcoU9FjGW+lnKULxK8wN/priL4UcXhZ4Ogae4oy5+bMBZGGdMX?=
 =?us-ascii?Q?LkOZEDJXxtN47oWIigyUvJRbMLsVeoIwmoRs/nlz41Ud+ZA0Fg3nuRaeTXCG?=
 =?us-ascii?Q?zQsczBA1pgvw/5tn67KKaVA8CXJP9BBNKaDz9y66SdsrEH2fhOADNXcc3ueY?=
 =?us-ascii?Q?Ecm9n/LV25jP44VZ72qEBcdV+hSKvIKQSI9r2tB4Knj8tjlIJswbSymzzBXR?=
 =?us-ascii?Q?hdc5mt/tsKpz4qiy61ZjWp0SdaXPRtk3ACSjl7Xk8g/xVdhd071L4skC2F93?=
 =?us-ascii?Q?6unOrcqiOr4LM9pZvrh1sbX7y5pAS+RBC+N6Mftx3JRPp9jeszUdwQpXnFsW?=
 =?us-ascii?Q?oQcl31CICvThX0hUu4yhBWg8VbiI11cQMdhlfd4Sxyf7/53HExftdvm5kLAS?=
 =?us-ascii?Q?dsCynSXkEGqvcuR03HDvDcI0yRYWJvSN7txwbaiT49aAimmj5IJm93LNApBX?=
 =?us-ascii?Q?8VKe1UPCRlWf283v+lPBE3fL7aPIdD2CYaSdjhILJ+2RKsfh37o9yKe+4iRa?=
 =?us-ascii?Q?0P3WWJ3RAFBE9wVxpJs41rfDwbdTzu0f9acQ7DF+vOQv21nnk8CKE+Yguk8I?=
 =?us-ascii?Q?h4km4YkQcBye4Ce8sKWT0nbFXqJ5QyOzHqWy25PgApb4tF/+x/iLCVrMvf4f?=
 =?us-ascii?Q?PyIb9Mql+cXrNSfRKJbMeaUv4XnnjZAUX2oZswvcM1qJ7y85THoD8ONFEfAp?=
 =?us-ascii?Q?tz1emdkiheCuxpLzu83gL0IlDq/LIRVji4q0gj20U7jEXk5rpv8MGzJcolBN?=
 =?us-ascii?Q?sz/LfAYK1CsRGSQ0WeGLisUXmNgIiW0wHg8gJW5bJmVJicRjAP7FIBybOsvk?=
 =?us-ascii?Q?i7zo8NCW+XLi4ytXlJSx2uD6b7zb58fKlQ7aOtOgaFts5W+Max59mIbb5/L+?=
 =?us-ascii?Q?ubMmKBPx8VgLHjK6kBPbZFxWgMluR0uvA9nAkKpmgZfpnQNWikshFz4rpNmZ?=
 =?us-ascii?Q?EUrQQ0LuPemRu07hcyzl3wzd98R6K8xcOWYSHxIhB+ll3YuPUOdJG8QoR4zf?=
 =?us-ascii?Q?lAxMNbHDUdqA9bldfazWA8ZjW0RGGawKtd3sa7tl33DtuXYvu40yvj3ZCtzU?=
 =?us-ascii?Q?J34E63TrVUFkaUfUpwXbHsiqOAKm7dclZXJpBBEK5T0tJfNbqbkQc3PjmWQk?=
 =?us-ascii?Q?JnF3z9bPsGN4h49fYQosV1Wr+3OsmL/NFazJS6Yrdufl6vbDTVBS5Fy9YOBF?=
 =?us-ascii?Q?doWnlKf+5qGXOKLIjirkJBWKf3reXXjdrHJQCXCDcA49JYioUUfgpol9/B15?=
 =?us-ascii?Q?XZNB7LXrkZnablfv2mm8TsYiAJm+yOsRysDVkWg8RkbcH4WplMAPTVMDC+qS?=
 =?us-ascii?Q?GkeW5c9qUEanIXtR598=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3082.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 913b46b8-ddc9-4ed9-27e7-08dac62b13d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 10:29:14.4492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hoyrx32Ihf8nMpe8S/gJ2ejZ+dUlZAg88VJOTCb1Xcee8LPrxdvJVylBECVrp4g8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6735
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Hi Alex, Cornelia and other VFIO experts,

We are using VFIO for the user-space applications (like DPDK) and need
control to affine MSI interrupts to a particular CPU. One of the ways to
affine interrupts are to use /proc/interrupts interface and set the smp_aff=
inity,
but we could not locate any API interface in VFIO from where this can be do=
ne.

Can you please let me know if there is any other way to provide the CPU
affinity, or does it seem legitimate to update "struct vfio_irq_set" to sup=
port
the above said functionality.

Thanks,
Nipun=
