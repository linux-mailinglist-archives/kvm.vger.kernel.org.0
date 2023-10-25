Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A177D6C31
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 14:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbjJYMnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 08:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbjJYMna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 08:43:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42314192;
        Wed, 25 Oct 2023 05:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjJXxSh9jlHNeWNRxRa9+fNCgy5TX8zewSP/jOxrACz5AiLFn1NipQyr28fdoXrUkSIDovQNUl+AO1ZDslDSDN666DcIu1thJhEHspx87Xgv94uLHVq/NwRj1ZHZVj7TM6YfkJqyKwqhQUsjpDQ/3StZXF0IwtdTbjyTU3DQH+6VtnreFIReGJkOlpJXyb8KXXybvhO09G8UtJHLjBRYmT1/QQQjQJwBltP9q8UBcwRdizklhVVjPm2TndVK+WzpcYYx44o4ua/h7D3tLL8+QaCwcLVwL1pXD8j0jJ+SBWpkdwRLT+i/mlPx+aIuePFVEgojd795zRlPZQf8Jca5yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Ryt9rxTpUCxTp0sq7obEZXuzmGpMy5sCK0Er9TSEDQ=;
 b=MXoJN4ttuTzbLHrTuDE3+YY5bYSRGU8i6Yzt/MADwaMC5w/xd9m35NsUB9nK/5GwHvfq/Dwjet/6RG6gyaa8H0yLKONqHU2QUswGaE2PQi1RZmmxzDoTwxNPuRCAJ5ddYUw0HOA+3Z3a46FtvJI0LqpYNzYmzIwTbWzv/vR6MOycVPo3Gn913l85iIQH5Aj7hmMPxgxzHToGs9oW3wZqjvF/V7s9wvpxrMSOX+dKn1mAk6YUrXAW8RPoVy3Ehtv1zjS74lRfcZfWMReea4izPxTeNXLgCLDQbQvN/A62LRbZ2zAd4VZlz8s0R5rPxWvpUQqwwfPaBDyCDoJXu0stLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ryt9rxTpUCxTp0sq7obEZXuzmGpMy5sCK0Er9TSEDQ=;
 b=rD1qlDtCJ5Lm4+ZVAFskC+uS7LARWbCrjIyHh2ym1LuekNKFeGJ4srRXrwafMf3o4JJrF71cbtgKWqK7dD4bmvuLX1Pqp6nmKcBPK3CQU5+SinAJDNEjh407ify8Vz0C25K+E4ktjJtVTbQ1U1dJIFNIbMjbmDq0V+V2vUjIrhzVAnp93iHOJbgFqj3WtjN5x814psXMGCLDhwJ1SoJ7cu9Mquxl43SOGj8vuL+rt1qKHXstTOhj2BDgNpmLmZAgH1rGT4svhp/G60K7kAuVxDPovRl2QwVwJsWqpUuszfifzI9X7X+nUWHwV9oq/5SMFHI9Id8OFUNfvE7XPkzdrA==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 12:43:25 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::84:dd27:ba92:6b15]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::84:dd27:ba92:6b15%4]) with mapi id 15.20.6907.030; Wed, 25 Oct 2023
 12:43:24 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v12 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ/4T6dPreO49caEWsaHN/ceuQqrBOmsSAgAi/5YSAACTLAIABhTmtgAAJHQCAAS20AIAAOkSM
Date:   Wed, 25 Oct 2023 12:43:24 +0000
Message-ID: <BY5PR12MB376386DD53954BC3233AF595B0DEA@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20231015163047.20391-1-ankita@nvidia.com>
        <20231017165437.69a84f0c.alex.williamson@redhat.com>
        <BY5PR12MB3763356FC8CD2A7B307BD9AAB0D8A@BY5PR12MB3763.namprd12.prod.outlook.com>
        <20231023084312.15b8e37e.alex.williamson@redhat.com>
        <BY5PR12MB37636C06DED20856CF604A86B0DFA@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20231024082854.0b767d74.alex.williamson@redhat.com>
 <BN9PR11MB5276A59033E514C051E9E4618CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276A59033E514C051E9E4618CDEA@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|SA0PR12MB4557:EE_
x-ms-office365-filtering-correlation-id: f6a88927-b266-46f2-4529-08dbd557fabc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iNH3BKbwj+vLhq93IVtcss4LBLvBYfNt9BkW5nxLLwk/yuDI3ygNjNWb6NGXXaMteDkdXGVLuJjA/YhI+0cxWR3ezZ/TRV6JqKe2BIoS/A7hldVUxhEKk6V/Xh+w19xtfS0TtO0Ah+UWeWTjp/Z7wNzXhDvsvJIaehxL7n/+cKp8PvvfllOGLxva2AQBNyUB8PKvZgCLvcwOCVso3bGNN673CFtbmZVkDOjT2olrHTL5qIOLlGxk/HqRvdtIUUM+kW2Mk78gLWvIDOYZy1Zv8qzyO2TPV56m9wBbv9/FbaiGinZuEUQfG39elZrY5N9UE5zzxSRauLea/sAvbc9KFjld5dPB+2wJU6+ARfFGoA4TuVbqFyIx31PX09QFEgnAXRV8xhhuzaVC1VfdJri5vHg6LwA+Xp6CddA6otmhrYx0jm7gAX14PS70Sxm06ZFN18weHeFJPNmnKar9BXM9i4h3m4Qbv4wSbFCiGkZVoftuuORP9Dqge7Vxv+mmoyyQdaErzklJRh1SKpq1o34xFNVfAe1DXMeqxPAf+5ey+wSfJGZgTMHL0RpR7rje3Rz8P1jhrlOQZx8PL6b9atl3e4X2X8Ay/rGl5rEjQIyNLoCzuW7FgwpvxboG11Q2Um03
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(38070700009)(26005)(38100700002)(2906002)(55016003)(41300700001)(5660300002)(86362001)(52536014)(316002)(8936002)(8676002)(33656002)(4326008)(64756008)(478600001)(71200400001)(6506007)(76116006)(91956017)(7696005)(122000001)(66476007)(110136005)(66946007)(66556008)(66446008)(54906003)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?5agjQCC60NZ+ZF2/3VN36Pp3hsSrYG00TVzWsPKrpGc3CSlM7ODB0Uy9b3?=
 =?iso-8859-1?Q?mIAac9hPdCOkLS/xMjXK1GyPngo1bSoknG65fM3uBKjUis1n8Cesf8m4OS?=
 =?iso-8859-1?Q?5m3+sLwx1i8xZZa7+NBQoryPfmJQQE13zxUid+kzs2YegI/riqFrzPv45x?=
 =?iso-8859-1?Q?rdZOtT4odWwOYF8VLBBf4R7pjHvtMlGmyrbDIWL5mT+PGalF2ZaNRC904C?=
 =?iso-8859-1?Q?6koSG0EjtutZ1MKhT/FNlfkPE6etViDVDpTI9HgUqsz7rCtbfk9/ZfMsYi?=
 =?iso-8859-1?Q?RyMJxsUfTOOrDiILBlsMywwrk61ZjsQd5EZ1raGFGp6GvcLh7G/vFsTKVv?=
 =?iso-8859-1?Q?/FK0utPrqY80urTBOsxsi2w7a0JUtg9xn/JwEgLI2JaR4SV+AUigBuGOC+?=
 =?iso-8859-1?Q?G5VjYEg2gZx8y8LHf1sJJ4fckBL5WdOU4hwUBgTpHz7H18kMGgbUN8IbkT?=
 =?iso-8859-1?Q?A/pS6oWO11SCAlA67KeAvfSbghSx3mz1bLBmAUs9q4eWtZnmlQgqBhDQZl?=
 =?iso-8859-1?Q?aQkdVdYmwSnVI1NYJ60VW04VGS7rqvQDljAg/3dkWcc/vOyQjcaikLnLXX?=
 =?iso-8859-1?Q?xvioiW70s5eFR+fcrU7MWyrdElF6J28IX1ltz5YJGW5iK1ACU0HkKb69S/?=
 =?iso-8859-1?Q?E9+ODUuGmcgcwidPiUS1fyPYzBEXryNGC1fE1h9bVHhaXmFT4iPAstT5QC?=
 =?iso-8859-1?Q?QZ5P4wTWMN0b56iPG3Oj3BK4Fm3tsKpzepE1DN7umVPosmS8ZF0kQA5Guy?=
 =?iso-8859-1?Q?pt8TMZ1fHw8GbnFq2Dy7v3NRk8x7tVrYNwXowJ77nI4EYVyC1JwFTW/Sd9?=
 =?iso-8859-1?Q?gJswzla2ERlZpkTjHBU/2+rKiHxiT0kCEqPlCZw+FCbdAtV2/mNQkGcF2u?=
 =?iso-8859-1?Q?t7xMdX1Qey4cS0EtkipwdvRB09/zC7UqswMDG3xKuNZwqwH1I1snLEBXRN?=
 =?iso-8859-1?Q?KWYEA23uTp+1ePCR8euSkkiN2ZbrNlG34n9t+P4nJTvsSBiwJoR93R6DmV?=
 =?iso-8859-1?Q?RFG/Ke5j+ZPch5OBaS3TEGvWOJagcPEh9W9hui9rLa71zCQj7iRqylMKK6?=
 =?iso-8859-1?Q?MZHsmPZwx+5XJX00gluUpBCXxY6wS2CwTyyU4tcX44oog8Uqt4sfepJIf0?=
 =?iso-8859-1?Q?z7HadDByo61qaKSfLojmbMb7oem5isykG2RlzDiieZME7+Jsw8oeT4YDyH?=
 =?iso-8859-1?Q?h5ks57gd1Zs69gBPOxxGBUP/Q9UVDpDZIslt2gWoXAKteiwS2t5xoIbxep?=
 =?iso-8859-1?Q?35qjxassr3fgpyyxeQkUzAQkguht23PiKn+2Hi9GDe/339pjE4oLdvtNMM?=
 =?iso-8859-1?Q?g4wFH/j/FpdqM4EfPaRA3XwEu5QaxHobyLXriPgg3d+SPddOqHJolSOIWW?=
 =?iso-8859-1?Q?uBsI6iDMjG70+i4Uy2+NP/JvO3v15T6ho7esnRV7wBcgEWHoVdbABI/sJS?=
 =?iso-8859-1?Q?7nPSix8F3zKPFhCFHWxJ7SMnUfObrdCp/8xdVXRjwzpvSLn4zikBAd2FU8?=
 =?iso-8859-1?Q?aSE3fYogCOEctDxHx2lDva/lzXzILkiDLr1xAkbTOJNykmVWKNFMbC2kJz?=
 =?iso-8859-1?Q?n7CtRqY0d4FxVCZN3oQlW7fJ99QCafBqv0aaRntO5ODTxpGxcdIt0If/mH?=
 =?iso-8859-1?Q?/33Uilzg/hauc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a88927-b266-46f2-4529-08dbd557fabc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 12:43:24.8491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V25wH8Scw1BHir/C0ZXyEYlfkJhrNCXVINoBdsU82Wn5VeCwGZ5dPh0R+AFUDDu08aeRZLcDaioEpvXFod7yPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While the physical BAR is present on the device, it is not being used on th=
e host=0A=
system. The access to the device memory region on the host occur through th=
e=0A=
C2C interconnect link (not the PCIe) and is present for access as a separat=
e memory=0A=
region in the physical address space on the host. The variant driver querie=
s this range=0A=
from the host ACPI DSD tables.=0A=
=0A=
Now, this device memory region on the host is exposed as a device BAR in th=
e VM.=0A=
So the device BAR in the VM is actually mapped to the device memory region =
in the=0A=
physical address space (and not to the physical BAR) on the host. The confi=
g space=0A=
accesses to the device however, are still going to the physical BAR on the =
host.=0A=
=0A=
> Does this BAR2 size match the size we're reporting for the region?=A0 Now=
=0A=
> I'm confused why we need to intercept the BAR2 region info if there's=0A=
> physically a real BAR behind it.=A0 Thanks,=0A=
=0A=
Yes, it does match the size being reported through region info. But the reg=
ion=0A=
info ioctl is still intercepted to provide additional cap to establish the =
sparse=0A=
mapping. Why we do sparse mapping? The actual device memory size is not=0A=
power-of-2 aligned (a requirement for a BAR). So we roundup to the next=0A=
power-of-2 value and report the size as such. Then we utilize sparse mappin=
g=0A=
to show only the actual size of the device memory as mappable.=0A=
=0A=
