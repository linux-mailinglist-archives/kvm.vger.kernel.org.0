Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB26D3628
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 10:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDBIR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Apr 2023 04:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDBIR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Apr 2023 04:17:56 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2046.outbound.protection.outlook.com [40.107.6.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4384191FF;
        Sun,  2 Apr 2023 01:17:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be/sawnXJnAs+BaOOGxm4DfAIIr4p/Er5qpXduFx6HsKYyZnvwmxr7iyiZ+49841nllcP27hdeZj9NClcLUsDtnDUYapR2zCWjtzOlHnBA6kZ4toMIA/50rl7e++p5dp76gdBptW1hIoLZs/zB2E3IZbyK2ywQ3wGprctKpm9vsSBUHMi30Xbf77abaSm+gURmRszkDoNoCnnH00aD8Cn+XOTRkZ7He7I5d7+vuQ7ZD556d4Hu2rczk466UmU85iK5OEH8YI0y5zI4QbrXKVZHazSJvn58VXsy6Z6et0zjJ0ZeIdHEQesRfqY9nd6QHnAXBQrKOdIiSVfWPnnW+EfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZen/VKhH/3PUumLxF1KFAG1TxXlaO+eF/GJX4cEa0M=;
 b=AWHpjQSCOSEYsZ9+5D0J+yyyKNuu8fSvQK24TX3cRQbNRrRXEMQgCIa7a+lGLFg69y3rcA3YhYir4zhGMc5uHVw+dNwHanCV+L0il+1hsu3uYKOj5kXyluBlRhj3f9BTh0C2bsJsDMaWTCEpT/Po+60v0p+KTEaeUuEL8Ow6neoQAJePqQWablnQEgEhHOoVfoyYR7OWHlT4o6Akkaumnza7Qj/kQfNtMCkS/eVvQo7meFkDsu6t1tV5McsD10hJxVNpcssBAw1UHKoxIZKArwe0Q0xJ4IzmT4fBxanBOqeMmQipcBJOYAfW89cejJvvXbnLiHXu9K/SpZzCOQH76w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZen/VKhH/3PUumLxF1KFAG1TxXlaO+eF/GJX4cEa0M=;
 b=Eg6JIo3Hk8Wl+EbUtA85d2MBH5ceABdUTizNnALVaVZi0+A2xFKMPXUivyiGEy3rJD+YBuZS17uCY1kfDSkvliLFMdutEGR8lb2/Su2k6u2WV78Isn8se7C29pW8y7SVgqMj2EnIwmowNnk2+vU5ZybcqJoS4ixrGa840rcvsus=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by DU2PR04MB8581.eurprd04.prod.outlook.com (2603:10a6:10:2d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Sun, 2 Apr
 2023 08:17:52 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::b28a:f4f1:8415:221d]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::b28a:f4f1:8415:221d%4]) with mapi id 15.20.6254.028; Sun, 2 Apr 2023
 08:17:49 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     Viktor Prutyanov <viktor@daynix.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
Thread-Index: AQHZXon0whv8NnC6hUW1jNhoqDcu6a8W1qQo
Date:   Sun, 2 Apr 2023 08:17:49 +0000
Message-ID: <AM0PR04MB4723A8D079076FA56AB45845D48C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230324195029.2410503-1-viktor@daynix.com>
In-Reply-To: <20230324195029.2410503-1-viktor@daynix.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|DU2PR04MB8581:EE_
x-ms-office365-filtering-correlation-id: b094cc70-767a-45ec-1398-08db3352bf9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ihDH0sM9vhKr8I8LhAHQpTJO5H0T8I00DTY5Ngp58smJF0s9OQ9Z4JqDjYczLphaftit993HlgvQvOJpLKrrZFni9KHBb6y5Bok6raFDm3aHogaIr+GZKE4ycO06aslqSf4FsJVgyJPSCue8lf9whjq0jvPo2iF9kk1LPN0pbX1sWm+9n9a7uLUfJPHbg+zagQk+2QfdisvrfcN9dRdkQsB9JlYQ+qYZNks+f/ccaXAy5WRkDFyGDPpgxDipO81PHJlbvLJEcarDOfmmCfcJhO7NbIVxa1jQXSZAr3gX529MXjkZgKILkqycnBDy77xxcR0FOpNfcNxCs/HZiUlsTc+IFbQ+mrqHUws6LXJN5fK6iUBrN5Ll+CN4ndySq0i1TwAt8NnUjkgwbu+LfCxGuyN+zMq8cubkMktdlfjwMf9GAdmgm884KJeXIIxp81rHm8j5t3xUg/KlyDhF3cLn1iVY1p54FC/iLh7O1i7LVBqRldKM/GyuPr6dU2VHtH16oOytWHIz4PybI8amuXbyTuctXFVdyMuFEj+70I7xqpiPDOQ/ttaP5Dr68aRxzcBFekPoCFs+Vyl0ch2o+yjEqSFTwxR1Nl2h8gk26dDgJ7Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(376002)(366004)(39830400003)(451199021)(55016003)(41300700001)(91956017)(8676002)(4326008)(66476007)(64756008)(76116006)(66946007)(66556008)(66446008)(478600001)(316002)(110136005)(54906003)(8936002)(7416002)(52536014)(122000001)(5660300002)(38100700002)(186003)(83380400001)(7696005)(966005)(71200400001)(44832011)(26005)(9686003)(6506007)(86362001)(2906002)(33656002)(38070700005)(66899021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?9F/PuT+bOm0sWFf6giLu31X3EDVF6Kyfy4YhqsTfMuQEAnaKjgJ94Ufzp2?=
 =?iso-8859-1?Q?0T8im7CJsEUzxjpjIGXA7mP4TfdUFeT6RQ3MK4+RucsVd4T9G5wXtuTamA?=
 =?iso-8859-1?Q?yS9DyXmkxEFHH4SJ5oaWNQgHZfKdplf68zDYs9ycDRtRtUbtlG/EbY9cb3?=
 =?iso-8859-1?Q?s/r11pJ+sqg5EUw+WOjJpipwpPqU6wD54wbr021aa0T4IxQAZkIHkpmd5Y?=
 =?iso-8859-1?Q?M9EcxVvXvsXxJce8f4C1BlOCqSgtrS+Bcl5MYfKcU5KREu5bM8AuGX15t2?=
 =?iso-8859-1?Q?kUqG0pLp9IGAAm2m85XGKeiMtqTsVC7X8p4s2pkyGtF75PwDl2SfU1Ox2y?=
 =?iso-8859-1?Q?GqqKrocaeyZweDF7s5qZhnw7diE2K09Dv16nbfDnPeLLOkYF0c0syFgpyW?=
 =?iso-8859-1?Q?QpmD/tqrH14L5kK/rpbxGhN8pnKvWykyAdyI3Ky6p/7NelpPyaMrMv+qFM?=
 =?iso-8859-1?Q?m5XS/YZLJPnTUTTUsIEJPMSG4XyaDZsiZZ/N5tAbl5xa2A+6/LZYNuo6Sz?=
 =?iso-8859-1?Q?mjH7dAyU5LVF+yB9hVXDRTNlXXJNykKxgmBNqn8yA4HzaCFhSoaHb1D21K?=
 =?iso-8859-1?Q?o1voQv+T0OiXC6tM62ReQ/rBVy5s70Ahclt2LHqFphUDXOinSdSvT/SM1V?=
 =?iso-8859-1?Q?Q96rhu0UCm4+gDs0Is0U2J322fe36YcY1qGYvRhnYdpP88MNusH0t5Gal4?=
 =?iso-8859-1?Q?+7wt0b9AxmY1a8V6aEtF/cCRERA3RX25tV2c/9qlL4ksrnpaYvlFUuLXCS?=
 =?iso-8859-1?Q?UnoSqHdCZ/sfF11S9XNf+bYBlpndO6bnoxc0Kcnv0ZU8rkqliVIDo8T5xx?=
 =?iso-8859-1?Q?Ze6RPmoyZtaRlABM4dTMJwUHa2s76KAGrYR51udwXpUdGvlhVmeAmUIaaG?=
 =?iso-8859-1?Q?OrRAe7//vDUbUXump+8xKnQT5e92EYsEiaMAw5s4/0ccUVuZFRwGIDSoVc?=
 =?iso-8859-1?Q?7+lAwd1foxSESPa9pSr8sUIwFJRfsJ6/zYqUvobUQQexatT10QnqbWBGWT?=
 =?iso-8859-1?Q?QHq1fvdlCH0CI/36UchTIjE9Zm+VHrlqJspA2btJ1W4wUbgUkPEZnIpB3c?=
 =?iso-8859-1?Q?jESIT+ql6Vcaof8hhpGpFSZ+xZna1K6nKqBbgG8P2ixsWIEz3YfYKzPf0y?=
 =?iso-8859-1?Q?ITZtwJf/q1Ok5CLZ2XiyEhy5wTlwnd8fzEd3HfJnTUrFy+zg8v/NdxSrS+?=
 =?iso-8859-1?Q?3EF0WWVz1jdQ+iTOFfzxxuO87Jqtm0C7Lucz20AhE07H39W0ntK9jk81qt?=
 =?iso-8859-1?Q?gym0oUR8VsZPH9kCi3Z+1NnA5lgZLCH0+AHyUugAYoOMzbQ4+Gl+EV/fYU?=
 =?iso-8859-1?Q?nlTpxQHmnaKWPMCuXN9o15XYuIMmJrENWt7jLJrc5JzbxzVsepfb7dqIgu?=
 =?iso-8859-1?Q?ETN7yJ2ZkNGEpFSNLlgNwf4LFF6bD0cBbAa7vTE5JuYXlSsSCEI+hRFsB/?=
 =?iso-8859-1?Q?t5nJroxsisldaU2PklUQEQm0XuC0VuVwIGWZ/xfLct6U3UG5c0rQFFeJUr?=
 =?iso-8859-1?Q?OE1lGcUFo4+BtB3GQWmfp+nJ2ykRotk0tUSlJkqbyicb6EzyaSWIDd96yj?=
 =?iso-8859-1?Q?1v9QkxXCuQHsjd8vKug+/eL/yperZCwqKwDFVwmuKk5yDT3e7RsIlFCMVQ?=
 =?iso-8859-1?Q?VbP8tqj2C6DGAo5Do5Ag3KOGH92tGOF72e?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b094cc70-767a-45ec-1398-08db3352bf9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2023 08:17:49.7946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5AoteqCKB84X3fB5/BCSJOgSecRRjanInVez0otpTLu2ylzmRlBduS0Pf2lSKHvjmb5Z6CNNRHEkotWrc1Bu01iwOA4OUV6KyosW6q8a9D0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8581
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Viktor,=0A=
=0A=
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c=
=0A=
> index 4c3bb0ddeb9b..f9c6604352b4 100644=0A=
> --- a/drivers/virtio/virtio_ring.c=0A=
> +++ b/drivers/virtio/virtio_ring.c=0A=
> @@ -2752,6 +2752,23 @@ void vring_del_virtqueue(struct virtqueue *_vq)=0A=
>  }=0A=
>  EXPORT_SYMBOL_GPL(vring_del_virtqueue);=0A=
> =0A=
> +u32 vring_notification_data(struct virtqueue *_vq)=0A=
> +{=0A=
> +       struct vring_virtqueue *vq =3D to_vvq(_vq);=0A=
> +       u16 next;=0A=
> +=0A=
> +       if (vq->packed_ring)=0A=
> +               next =3D (vq->packed.next_avail_idx &=0A=
> +                               ~(-(1 << VRING_PACKED_EVENT_F_WRAP_CTR)))=
 |=0A=
> +                       vq->packed.avail_wrap_counter <<=0A=
> +                               VRING_PACKED_EVENT_F_WRAP_CTR;=0A=
> +       else=0A=
> +               next =3D vq->split.avail_idx_shadow;=0A=
> +=0A=
> +       return next << 16 | _vq->index;=0A=
> +}=0A=
> +EXPORT_SYMBOL_GPL(vring_notification_data);=0A=
> +=0A=
>  /* Manipulates transport-specific feature bits. */=0A=
>  void vring_transport_features(struct virtio_device *vdev)=0A=
>  {=0A=
> @@ -2771,6 +2788,8 @@ void vring_transport_features(struct virtio_device =
*vdev)=0A=
>                         break;=0A=
>                 case VIRTIO_F_ORDER_PLATFORM:=0A=
>                         break;=0A=
> +               case VIRTIO_F_NOTIFICATION_DATA:=0A=
> +                       break;=0A=
=0A=
This function is used by virtio_vdpa as well (drivers/virtio/virtio_vdpa.c:=
virtio_vdpa_finalize_features).=0A=
A vDPA device can offer this feature and it will be accepted, even though V=
IRTIO_F_NOTIFICATION_DATA is not a thing for the vDPA transport at the mome=
nt.=0A=
=0A=
I don't know if this is bad, since offering VIRTIO_F_NOTIFICATION_DATA is m=
eaningless for a vDPA device at the moment.=0A=
=0A=
I submitted a patch adding support for vDPA transport.=0A=
https://lore.kernel.org/virtualization/20230402081034.1021886-1-alvaro.kars=
z@solid-run.com/T/#u=0A=
=0A=
>                 default:=0A=
>                         /* We don't understand this bit. */=0A=
>                         __virtio_clear_bit(vdev, i);=0A=
