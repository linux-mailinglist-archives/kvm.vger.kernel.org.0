Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1466E07EE
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 09:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjDMHkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 03:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjDMHkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 03:40:18 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200DD359A;
        Thu, 13 Apr 2023 00:40:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXBKzdtGxir+WIb04pyMYROvGfwbZV4RqQzGD/CMhsAlBdec3Qmt1sCBCrec3iyZo0hHGHdrb2D4FeSrYdAupROpnGo9E4L4Fi9sKg+5ZRiO+a5mhKLBvpgh+pDbwPIgRnsrRyFfl597g2IgS3xrlTcoticPlfOedRG3lI8qaxZpMlogBJLnsR5i+y+vaIQsGA/qiIuiAfGHB5+P+mIGj4PPrI6DpWX9jYU96bh9NzXQ/3a6Q/vUrbIvspvlMuBMKEDVgXGLfDMLkk+FIvCu68Q1YTF4sn687EmQlaW9enrdtG8ZQp5QjMNvk4b7TF396BIspNTAr9fgqPivZpRRCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yN7of5yYTe1rAyvTuTHTIUxNVqN0jwU/i3U0SQQ8xaU=;
 b=iY1dy3QBgrw7rvWgxWTKL3Qbk0+qabMUeTHPcBqbAG/rbmq2tQmKoX76EGKXbHKymc3AJU37FBncDNFuNR967Q4+R+/Eefigmtge/ua3xkRn3RlLHIIG9krPTjCMMWH4RrtFtjxEpPko6JLegDL6SJWTl3DWcnn2sIbWQLN4BFnosKOIj0vgYWHYGknRtMaN03fq4pB9syHCu0TX4QBaVzc4t/L0V1yF2JkQ7P+2wTc17BrObGB1GNrySn87+Xnc0l7EZNbxDnXgm7HhK8eY5ykhTBQWOKzLPUHngaO0kGB9p/Lt+W/UAsTWoe3QE0YTpg/mxfHZiyiPQLvkOT9+mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yN7of5yYTe1rAyvTuTHTIUxNVqN0jwU/i3U0SQQ8xaU=;
 b=F4yEkss8yAuNcUY16kgbRC0DqjOwVYzRs2bx3buGG0DnOw6T8+qddBLPopDMtpUsb6TRMBf5QUUANSfSVEWzfmra3dsE3jHIG+BHJjEsp1mD31ixbim0Ty220dm4LhIjLc2aVtPe6suSFyBhTVLHWD4TMuAyKEa57GGDdrlQ30w=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AS8PR04MB8867.eurprd04.prod.outlook.com (2603:10a6:20b:42e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 07:40:11 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 07:40:11 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Viktor Prutyanov <viktor@daynix.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yan@daynix.com" <yan@daynix.com>
Subject: Re: [PATCH v6] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Thread-Topic: [PATCH v6] virtio: add VIRTIO_F_NOTIFICATION_DATA feature
 support
Thread-Index: AQHZXon0whv8NnC6hUW1jNhoqDcu6a8W1qQogASvawCADXJe1A==
Date:   Thu, 13 Apr 2023 07:40:11 +0000
Message-ID: <AM0PR04MB4723AB600C87D77AB486D035D4989@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230324195029.2410503-1-viktor@daynix.com>
 <AM0PR04MB4723A8D079076FA56AB45845D48C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230404141501-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230404141501-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AS8PR04MB8867:EE_
x-ms-office365-filtering-correlation-id: 910bbd23-1e6e-4b22-e082-08db3bf24fe0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xHKuRs3wXqjcv4wEB3/L7wFsIOQe1wsb5T5jO2qvPkTu6AJVZni2dh09GKhxIc7R9SNl6XWjEOLo0AVB7RNCYjKNAPYLF+Y+MLFTsoqnRHu24d6jJepoYMUuiV6DaqC/8gh1Os2aq8B6j4e1SUCYLADRNydBW4/IQfHJWyy44ylWMtH3Ec8i/d/Ydvisw3NekhckGA02LJ64EsD9zl0GJ3uUduXtqW+w5itDMG8nZtociUwRyRphc5aj+u7SNMEUbYxkYbFwFqxfZKNCkVYSzqBTSBvjHl08fvsKYlWbpdmttddtmIwYkguDr9oa8WQm3jw24abu9iCaYqfPLFW8pn6A+8y0/2s0g66XftYC6CGESrq/GBXfCcEKTDERzLxO8eD1Anc3hvm2aiWnNX71drByXdyypsSZh5sMhvjRcueUf1vPUADt2ssEuNqAl3hRrg3fUw6ZHlt/6IbAW3c9mY+JM5RfB26h7HV8WnmvIBdxASb+vk3FyO8BSJSK7yQQYWXCD4T0IAyDziGWC12y83pd1b45++mRpLA8+tzvc8lVpJgLkvl2w13l8e/Fd9azs9Ra8M5qpKjjpHSQ2Qqa0GsSHXFbFVhXDyFkXZuZ2gQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(39840400004)(346002)(376002)(451199021)(5660300002)(41300700001)(33656002)(122000001)(38100700002)(7416002)(2906002)(52536014)(55016003)(38070700005)(8676002)(86362001)(4326008)(6916009)(66556008)(8936002)(66446008)(44832011)(66946007)(558084003)(64756008)(66476007)(316002)(91956017)(83380400001)(76116006)(6506007)(54906003)(26005)(9686003)(186003)(7696005)(478600001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?h3k5NoenwLCSxpF6bjMiq7oPzLUd459Fo6JOhdpVthXs63cWGb2wK8R4Lq?=
 =?iso-8859-1?Q?oBh/v5/7I4fNKdqH7Bn3srf20MrV4QrUrodyU+kkmtjSHWtjTNliHAamcX?=
 =?iso-8859-1?Q?rzUoXqnsgTS68s3iwg7Z+dZYPziDes6i3h1fRe5SKM76i4zUoOvN5w96th?=
 =?iso-8859-1?Q?z2MtclDhh6i5sIQXUWHR51opBxzuUVmI2j/OMQlXik4sBoJPpYS5jwlyF8?=
 =?iso-8859-1?Q?3Ut1mOGpJZjJVLCsyhPre/P17IKweSzf8fIUpuOI4adqKrJxLYi96L7Z1q?=
 =?iso-8859-1?Q?h4VcZ2kaGR+/TkLI6gLuvAHBq7zK5/cOKNl/n6+b32oGS0kex6GX8+69an?=
 =?iso-8859-1?Q?P3RSEetjPOXmcS/WPi9u2tzYhlf/uvb6bfZt+zIJpFTwEcbKIx4wemkmux?=
 =?iso-8859-1?Q?+p1qGzdXGJawwCIAye0RfBVQxT4z6W61Z97o6Jh2QhK4OIOhnTCqq26sqC?=
 =?iso-8859-1?Q?YqY9BinoN2JJXfT8GMTXIMjBntFIOq5lXyQmM4UdoGpVpRjtvmDGYIvfu/?=
 =?iso-8859-1?Q?BcNvCrpt1FU0OptkNFROjgcgMDsB1UeD2RGiY/4mGY71XfGsmFB4ifpWA3?=
 =?iso-8859-1?Q?bth9Y+Kp9uvIGKRJWJF6fAWYA0dADBHC9GbhBcQoI1YLb5q0vl4XUkQw3o?=
 =?iso-8859-1?Q?Qvy2kfCCwfkBNEfo0Ww3YvKeT0i07aTQjLO0X7NaxDADJCDRjN2bbpHz3p?=
 =?iso-8859-1?Q?DEkv0+Ymlg1V/c7rDOhEgtLNGT4d7vEFWE/1EsWmzINxFeTv9+6J2LS3wj?=
 =?iso-8859-1?Q?vL3FViTs2Sp7kZMczfIXTAaNELlicnINdyrRZH3kaK5vkXlmSRhr9md3qd?=
 =?iso-8859-1?Q?jWVr7FZk7pANT2qRl07llfb95qrWRQ1aLZa1VQc69WIxfUB5ThuaMwLv4X?=
 =?iso-8859-1?Q?zDie18lCbTGSz4JrMPP0wxHcCDJ4w5ohCHn6ZUzizZ92T5g1kilkAkKN+Z?=
 =?iso-8859-1?Q?5f6X0LlTBFG0+KcGKyW/X+I5W2A/R/THhEP5p0RrXJ65btiqWHt/gAX1zH?=
 =?iso-8859-1?Q?zjfj9Xrszlhzu459D5Re6NPDcbKIdD981QdahMDunqW7634Tpt4N5RQs25?=
 =?iso-8859-1?Q?Qt9M076Q1v5in2W4B6NaPP4h7FQ4ybjuwsBObiAcixdspIog7f7iauCwAe?=
 =?iso-8859-1?Q?7XRp3jt89IHitP9cfw+7F0GxqczXZGVxfHBc1Vjh8xRWEDnit2dhk9NcoF?=
 =?iso-8859-1?Q?RcSqUqCAdoSQPjl7bZin7FhahUHftrQQVg9NBtXcJ6QYO3Ct5Gjjejidkh?=
 =?iso-8859-1?Q?DcEdj2rlQsF15JfGpzaFf5Qnybris5rEjo8+uRWemCKckbhEUbDc7ndGUf?=
 =?iso-8859-1?Q?YWnBTi8Byb9TmNhqFCfMcCDTGULXG5XEi96qK55Mlrv8L3Fcu8rx9RdtWV?=
 =?iso-8859-1?Q?819k2a9gof0i6rJiAN1+CSBLEmCFk96vCL7EURFrDSiGmixHzy/PmVjXxw?=
 =?iso-8859-1?Q?fL1bZQbRRluKyfRbIzZqL0sKKFjFJiPRE2mSSd08Xe/EuCZgvk6uO8Gdwb?=
 =?iso-8859-1?Q?2YLK99qyXYMWb/K1bkvFnmAZL6PNRYrV8G2D4flb8ESSO/XnzHDXfJqojT?=
 =?iso-8859-1?Q?3Vn3579basVNmrbZdOamhj/i5FtcljhvVfNH6rlhqrqKE1TXawUjmWn02K?=
 =?iso-8859-1?Q?LcFWuMJY45mlTzSn5hQTDCDzV5Aj2jArx/?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910bbd23-1e6e-4b22-e082-08db3bf24fe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 07:40:11.1011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Lzi3gndnVukxAdnbuSZDKcvEYdXrUkEKF9We9KWvh45LVmNDppuiD30ZzEAa2THXY6k68txF9DOSwtCzejGEkQ+0bTlEBZ60rC6+3/16VQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8867
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Hmm.  So it seems we need to first apply yours then this patch,=0A=
> is that right? Or the other way around? What is the right way to make it =
not break bisect?=0A=
> Do you mind including this patch with yours in a patchset=0A=
> in the correct order?=0A=
=0A=
Ok, I'll create a patchset.=0A=
=0A=
Thanks,=
