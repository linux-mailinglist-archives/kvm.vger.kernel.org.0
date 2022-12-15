Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F51C64DD39
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 16:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLOPD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 10:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiLOPD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 10:03:57 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8A62FBD7
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 07:03:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jze7Zbow7nXpY99UVnw/WjINTCIujIO1DaICqcX0ajSn3OBOfuA1rXkJsBJ711PQDsJdLl2W5Y2Pu4MyDyjInjG6PfmxvcTyUljHCdKnefPf4JK/b/ASlHaTxweV8G0tINggyg8p50FcGrO9AZTw5ieQPzxcilOzhlTSvmdeDGmQkRlJmEK6T9P6Ip9egK8HkebhBVpeUM6scKR/0LFBq2hBUJ2soiIlCqz/xB0l+iShR0FK3Fh50A53426IwOqomylicC4Q4B8SJXj6hgOIKvA7o/rA+KNtfChLdu/fsSUPY8wnPixm2oIctv/BKnJ/WS4VTVe0gjntJ1qOjr0WCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdTSWdI4sUoAvRVSQn70ecn5GMYpNt2hnvHP0XPL7hs=;
 b=GCjHe0KGrHyGhMBgQ2sDPP3P6NPNecIC/U4/hrdXq/Hw2PeX/pVi7NAGVuMMzdKYC1sZXVK2cQoUG4aq4vKQ5/qO+a+57OofAY6efHuv4gs+jM7uYHYiXFIbeboOMvk0lryfiuukkWPPg3volRo0aieb0PjKp/xwW0gPisMPobMnDFyg8dsnFLseYLcD+Aa+RJDvjaVkclSDPOlUQZ9tgeiQstpLHl2qu5oqsBmyb+dCbrNJezy92flZ2ouv6SivhBZrZxspZcjecI5ZO0T7sIeHvulwyB+8jdWuXc9z+R/8fLEB5oXzNh6k08YQDdD2wa7x67gNgziDz1wF1MpNWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdTSWdI4sUoAvRVSQn70ecn5GMYpNt2hnvHP0XPL7hs=;
 b=AkWF0LRnoMpoUPZqRN4ma7VRycwuoJMfi05kW/s7edam/eqjjCQtwagej4eOyXnGlLE3YTcHRaAsLytRtVHaIB81RkpvkeXgEU2nHXWI5cmV9kPZHP6uBHkk6WWgFLAaAWml6vlNZpLhPnW8h+/Vn8lyzsq4Ohx/r33AiwymsxKvlj9n46LxCB0EStjuPkPS5ScVKx3JI9sTvt1miHwit8TCuQPjE0HDDBIWwm/ujD48xs/+CuPu3w4b681JCJn6nvHCBxwVmzOhSpTHzflql6xjuATvUX4/+uBiZzTAWzfEmriBko3JtQu+28X/AcXvLDnF+VaJZ5jtnZRk+6T6DA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8120.namprd12.prod.outlook.com (2603:10b6:806:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 15:03:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 15:03:55 +0000
Date:   Thu, 15 Dec 2022 11:03:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V4 2/5] vfio/type1: prevent locked_vm underflow
Message-ID: <Y5s3Wkb5JoPCO1Fs@nvidia.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
 <1671053097-138498-3-git-send-email-steven.sistare@oracle.com>
 <Y5stJHFWK/ZLzA1q@nvidia.com>
 <4736f410-e925-3eb7-7c33-bcf4ad9b55a0@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4736f410-e925-3eb7-7c33-bcf4ad9b55a0@oracle.com>
X-ClientProxiedBy: MN2PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:208:23b::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8120:EE_
X-MS-Office365-Filtering-Correlation-Id: 53b13440-1c1f-4d5b-d0cc-08dadead95ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSmLo21WEjBcpfx/y+CBI4DlfDGsq0i2P+zQ1YNukUygPDkwmQeCHG9otj42fbTQUV8+LziY+ILERYrG5Ga0FjocdE7Q1m3dmzz4/WUihIroSx97tzx8uxJBgDQeVN1NhR9sPOWrAWbvlDHHJ4I0mk2dBeFkH7ox26Uve2uYGCywsMNdIpnoupo0aPkwD2jy7sWJ30gYOopCzLSZMXX9cuGUTalZIRXxHHiAHJA65YyqIEYfFpC0XJ70pj19Y8n+3gLc9W/aT+qZRxL5EiQpBKI9afnThENRlDu5DaK3n23knlV/d8XvTlaezq32tX/SJaOUwwrpPf4kVpiXHVOFXvnPwAa2jXGNG2urvLK/isOUy5B38+6hyzdQobRw8dbNSz4R9P61bvIZmATxqXl88DccSTG5vkPV6jWIEeKOcmK/5kIn3WEp+y1WfHj5JFxXkjN3AVaCXVkE6+TkU44KA1nNdFJXcOdJQ/7+0kpaMnd1/1KbIQMnz9GIQIBhhwxM5CT6inGfmmRGLUIvrhjECodqgWfz7lQr7WfAtVDNHz/N1mPdumckAyKwj/Uzkk0+CYewSNp3BD1bdYmnQ6OL4eaq8lbCCYrLHXRfuSfuiSgJCUs4OhJNLapbSF8gGYjRk/4Fjgd2Mv3AGPektfYodg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(6916009)(54906003)(2906002)(8936002)(41300700001)(2616005)(8676002)(66946007)(66476007)(66556008)(5660300002)(316002)(83380400001)(36756003)(4744005)(4326008)(86362001)(478600001)(186003)(26005)(6512007)(38100700002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sqSkjuJ7hS9GHPImjJSY3gJKqjbeE0nhB+ztqqjqnWaP0lBum4MS62ojN5YE?=
 =?us-ascii?Q?8PJIg9aOq52/S8AFt1CgRiu9Fos8Rmuo7HqgytRdiQ+IOuEfdURbPb+QIefL?=
 =?us-ascii?Q?8Tgknx1tFykDxaO55SWGu3zCR8B6ZttViB5N7zFNqLiSXuI8XTRsCvGaumTt?=
 =?us-ascii?Q?tOeIPF0LZEYO7vuwYsL2h8cW7AtKyfsWZqj1szpNUIEN0MlxgSdv1Hci/RbR?=
 =?us-ascii?Q?ZN/izfQK9ASp0xo8t5bX9I9RDNqU45XztrL97W+xm2fBHcsG7BshbQjDrG07?=
 =?us-ascii?Q?R1jyx259uKee3aG0HpI2y5MlPzQTbv57pS6Pzobrc9CJUPYe+zPb/HjN0aDj?=
 =?us-ascii?Q?xoz3AOOtmTjFgsbHptwPGMyX09Wt99a3H4lOg4KsqtUJioHztDasW5sWZJgB?=
 =?us-ascii?Q?Z72xxCf0JVhPR8qGYhdyN3nVDLmpc2jh3C2f6aCcvTMJQ/LXF2NdGZnLfHmD?=
 =?us-ascii?Q?q+iLKXUf2mZkc9ptM1kEY8XWIivbXo4CiRp9HQfYdeJ0VlEIBu3ZGsM+b2w0?=
 =?us-ascii?Q?eHPld4yD2Jl/vcdJR3fzO+uoZv0CjVaWykUsvzn33rEiNR3wm3wlZKZcssNJ?=
 =?us-ascii?Q?qXf0NZDm0GT8aQXAyxnwIZZF3GqWlAN9HH8dTci5Iuf5JNki6HKDxRyImwU9?=
 =?us-ascii?Q?36qp58hHMd7dbqxb6ZHGiVPvWyxqTgYDlMtxPhO1cpbgjqt83ARn9KT+vSpN?=
 =?us-ascii?Q?xBoXrEVAFXaqovWUm3TUbMmyzjS0t+PVGgTnC0qC1CLLeqzGZKaUn/3WqzX9?=
 =?us-ascii?Q?vKNLSYuIJGF5AycUaPCh+Z7cWaenN0IDZgHO6AdJemY0S+q/SzeXrXVQ9byJ?=
 =?us-ascii?Q?g9fboWYvcASo3e21WWWE+veByOYk72MOGph3GQaAMyLvVZ/N34ZAcAnbA3eo?=
 =?us-ascii?Q?HMcu9wBwGT7X3CSjiaKUN+b+n3HWZ5A7INZpzq5In004LWV35A14pjEeuZcC?=
 =?us-ascii?Q?JcQReCP3Vw27lJTQrkxoFC43X1lAkOQi6s1NfDHTtOJGn0zfS5NbNKmNcdEK?=
 =?us-ascii?Q?4YB2onkdlw5lqFY4zQ9vRLJVY89oEqtvBs5azbGNn3tQTeDH2SOfp+zcFYP2?=
 =?us-ascii?Q?2oCvX2pUxJqNGj89GN9lMCky1XKkhVBIUGLkj/cQ8DSzNSr/M/dPQAIujv9V?=
 =?us-ascii?Q?fH2ko40dx3zbviHiK1yEnNXisOpGjBzgzvX561bshmTMPPX2783GrxJR7ZBz?=
 =?us-ascii?Q?WOwBjq2PvOX5MsXycMvJiN9b7qowA0iwpF6eORUJ7y7pXXCVJ304pdHjEd2v?=
 =?us-ascii?Q?Ejjiz0qEo06ZqiOm717YJuigr2l6Rnl5FuhrwUIU0P5aobopPmp2qIG4h/y0?=
 =?us-ascii?Q?PPBGtLZ1ft4PIm3H3tTQzW2rC4E12MU4oClkByfjXUgeuacBmuh77lzFzUDm?=
 =?us-ascii?Q?qCMIO1j7TCenE2lXfO2Kz2/zZsNhLineDNUV57pHSdXb+mzvWeKERzg/KeM5?=
 =?us-ascii?Q?dy4ylHgYrOYp2OCv1Gk6ZIGdbLaE2b6zFjxOIAqnKmm1ueYZWCIKyBpuRxaX?=
 =?us-ascii?Q?ikt/CQrQ5JMeP5BoZf4V2pHN33TaNp8d7/QZbsBcJb3OcQepbOOGAd/93FZi?=
 =?us-ascii?Q?qd91iV3YsoTaLEpSEkMohZoTSZoVPIN5G2hnuk2Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b13440-1c1f-4d5b-d0cc-08dadead95ee
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 15:03:55.4229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGIzK6873wP6I3B5hEq1iXBk6U1xOn+7xK/+0QDfclvrq03Cx8srLDW9izRl8DCU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8120
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 09:38:42AM -0500, Steven Sistare wrote:

> > I'm not sure this is quite, right, or at least the comment isn't quite
> > right..
> > 
> > The issue is that the vfio_dma does not store the mm that provided the
> > pages. By going through the task every time it allows the mm to change
> > under its feet which of course can corrupt the assumed accounting in
> > various ways.
> > 
> > To fix this, the mm should be kept, as you did above. All the code
> > that is touching the task to get the mm should be dropped. The only
> > purpose of the task is to check the rlimit.
> 
> Yes.  While developing my "redo" series I tried it that way, but did not post
> that version.  Functionally it should be equivalent to this series, but I can
> code it again to see if it looks cleaner.

The big reason to split is that this existing bug pre-dates the vaddr
work and should probably be backported further. It can be triggered
just by doing exec..

Jason
