Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE27D48B1F3
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 17:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbiAKQVP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 11:21:15 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45310 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239725AbiAKQVP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 11:21:15 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BFEWpS001271;
        Tue, 11 Jan 2022 16:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=C2dJ7hWNAXv+iwFo2NcL1I039DaOAxdYeTITw7hPQek=;
 b=f9qBJESQo9jzAOuUHj4cnKzkQwlz7kHByCN6daRv93TFOAk5h3eKExJLplVNRJeHSNZX
 WeTgxDl3X6FpVFkY5lTjZEbGhTEcmYMfCjvH8RtylSBvsWRn9hGzUGsAS2ICQdIVaevw
 uPApHN6wE9Tnz8KccjGUczOHK18mot+pudS0LuRGYXWWJKjFl75vPz79tNR1BYRt3JIa
 M9r0vrG1ktU2ieXrnam7Uv3NXjLilp0lVqHHDpVe7/jrJ6bCvNemVfcuyixdtubPWOlL
 Hb9qXM5n70FammgBhYvkAUoaB7hXTfA5olbaRlIR/Ka/6d7SYyn+wISTA8NZx7E5r7jw QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgn74beu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 16:20:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20BGAT5m126580;
        Tue, 11 Jan 2022 16:20:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3030.oracle.com with ESMTP id 3df0ne8ebm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 16:20:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghr804mDU6IHbX2Zg4iTuPtJ9IudkRZ4w9iCA0bL/9rG9VL/XvYbst4sbH2CceaRLitlWGQxyc4WAXqWYj9IXkRvABdQ8TmPTDwPkPNRYT3XzDnMysJ9OYcWY9S23qINFrBvZLjWH0F7zwtux5sGlXazhdsmYhHgIwbOYgbdfQKtKDIQVLC0lKuEHKgoneY6KPVN8tFJTepO1kCguJgB6VW130wPLoQ6CQHA1vxDPd9ZJdqgGlbDlxVGL4KtNJy08opSruFd4KV0FwnFMB3b2YNhjYGxF2gMpNxmTvvBVh4v/EscHVHEr/URuX6dhn+mk7mO9Dh4q2dJuzGPo43C6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2dJ7hWNAXv+iwFo2NcL1I039DaOAxdYeTITw7hPQek=;
 b=QxKWJoJFMJ9oE79UpDM4LWogpALjZ2JynDEeZQKBuO81G/78PKrUpGOGc8PGE2E73vC4/hBVjyDJkaIoGzKJ6RecHONQJuG9z3dtdeNMtqVXRv4SO+ru4mN1GzDzOWP8XjFSa/cjU9y9TUU3xvV9WlHaocg4i3J6iKaMP669eka08amnKhFds00dmDQv82k1FZH3YOARt1x36zT4z/cjgOwlMCcS4WGDRXuwCGr/lACOyV+IxxAjHIIf4CJdhjoniBGxuuNAhkEE4Mqyj6t8BHCvwPqSphYhgeR7nDVTcOWAhuLeenWdDOGYi6WB5ECMT4aRlkLNLckASL9mNUclfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2dJ7hWNAXv+iwFo2NcL1I039DaOAxdYeTITw7hPQek=;
 b=pNio/ZN1N2Ih2BcKm3jP/V7xIiRRgDtmm2MaCvKNpoHl3r5xqVq4+5W3tiUmSKlP7b5Ofv3t5xpD4oaw2m2XACJFW05rsbtOmmO8dXctnm7LPeX9j7HNiHyTm0vdfuToKZS6TFAuYbAdx1uVaqRFUuOzxcvk4i86tHUS/eMG1JY=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by SN6PR10MB2863.namprd10.prod.outlook.com (2603:10b6:805:d0::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 16:20:32 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 16:20:32 +0000
Date:   Tue, 11 Jan 2022 11:20:27 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 00/16] padata, vfio, sched: Multithreaded VFIO page pinning
Message-ID: <20220111162027.3brb7ga3vgtvv6th@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106011306.GY2328285@nvidia.com>
 <20220107030330.2kcpekbtxn7xmsth@oracle.com>
 <20220107171248.GU2328285@nvidia.com>
 <20220110222725.paug7n5oznicceck@oracle.com>
 <20220111001751.GI2328285@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111001751.GI2328285@nvidia.com>
X-ClientProxiedBy: MN2PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:208:d4::26) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22d31977-cf8c-4df1-3386-08d9d51e49ef
X-MS-TrafficTypeDiagnostic: SN6PR10MB2863:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2863624069B9560D15515025D9519@SN6PR10MB2863.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zWmQ1TQ068yYWr6ckFVRSoar0NNB33zsnHkxL4prWSYZtvF8HP/VQSMWE7HnstysKZMv2Y+2+WDXT8EQh1/WQAUyaCyG1n/A3zNXvUb4F517qmHCQCyAwttTGYtuF8IMS7GEL1K8P0IzkwLDO082jYHnkq/6BTqjUcTEqx+8Z9AP+F7R8TT3gK7Mjy7iLWVvMyEJpg/P//dCuyeHL+R8oNzQkiOo7dIgrCcgJBASLEnL8nOXnnNifzhzy3DGKwca27Coiz/wmw5rCjjXSrwiBE+fZhfJQeg2aCVOhytmi5xVO4DJohBFr3dgk1wPGAELvpbhI1BhcF49COIxbQzgvfQrYcCXj5xxNfaCu1ena+5n+qyPPWk5Cakww3uixHNrwtc6uw/0SQOuzYigN97qF+Bszq/mte3ozteQSCZQyCer+gq+wmWgk+EQhmsVpDlBhT7fc+lIw+sqik+TDM8PdGkCxCifsj4wTbB1a8O86VdTwwtw5+tQIr9pwy7vxLzFe/etCzlWH3ppCKQLBqqhnnrqkZbuLVpPute1Wa8Xaq0e0XXKR7oWsEDfzBlv9K0Do1L0jx8NeNCN0whlWf/Cj4fY66T4KMPa4vTedkjENjAYNQzbysjdlzWxFsTTniKKln3b9VmNkc1cZfm8n328oppyVKR5+ezzCM0tVIUPhSLtU721xDAtxMkeRbz1+aZVIGe66aYhio2Bq0W7cLpLNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(83380400001)(316002)(1076003)(66556008)(26005)(6506007)(8936002)(6666004)(86362001)(36756003)(6916009)(6512007)(8676002)(38350700002)(2906002)(508600001)(5660300002)(54906003)(2616005)(38100700002)(66946007)(6486002)(7416002)(186003)(4326008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VVcAljDuZ/7H7TiI6EpB0VnYKOBurzF4nZyO8W/3j9pEbt1dRqN3ZQ7kIV9J?=
 =?us-ascii?Q?NCq3L4Nr1QI86yzhD6GmleyFiwprZskCawsjpNZAXlCU6l+iE6yf/NPDQL8V?=
 =?us-ascii?Q?fn4x7Zxw9rL8iwjuelIEjT3rMfYBdJ7hPTkCGpssUCBP0zfJp8Rlp8QYA70z?=
 =?us-ascii?Q?uyYv40S7NnkJ3b7cV4yMHOWrlWvc8ldDM/JK7Okxug+f+Jw8HH4fo2t16bbp?=
 =?us-ascii?Q?CxK9/eSndLldQ1YrFduyGEOGWDwUSeZiaIlLLYxT0RgY7tbKyTtk4PR8HNwJ?=
 =?us-ascii?Q?rQCV+PqbHZYV8ZlfTJZ+ADSLPsTLdVlqLZtB/fGixb65U9G/mJ/se5qt+hSN?=
 =?us-ascii?Q?7XFfqfoBSTzHwh6g0qrXikDcD7v1GKwTd3j+ytJXcfdz/LIjPh5sPAr2Ndwz?=
 =?us-ascii?Q?uzESoy/2Gqft0dEASlyyBHk3i7rOkdqK8WxeGWgBVyDBHD8Bt0Oc7DWfOY62?=
 =?us-ascii?Q?jPaqAN4KhnNLOIq46eo22gmW7Lv93SKFFKQzGpv1/Fp8Aql4eFrw2J9i4pBo?=
 =?us-ascii?Q?5Vjg+65iphiYa6+ibeYHYTAg/Xn//vOJhJsg7BQVm5GDWlAKW1RIB/Yzdm88?=
 =?us-ascii?Q?CtLhEmKg3bx8WtC8vOZSaTMH8r4tH0bKcOQJqNXGWhscYKUJZ6VOZ4p9iDW1?=
 =?us-ascii?Q?LvV8OTxTy53OJH4b7gPVq+SXsCal9xcFXZIpAj7CIgm6AP/VsoTebXuzz65o?=
 =?us-ascii?Q?e4WoLy2KcJxdvQOkUfSY7w0gwRo7a5HsFO13WPmWLMdF/vXB5hiHOOj1lLsl?=
 =?us-ascii?Q?m5f3Zp/djWCAYJwPWKcbPZH7eIHcEAt4HWHQT92s/Hng21SbIS+UzW6Oxnu1?=
 =?us-ascii?Q?1+LpUnI4/I5NWOCOo4nMBWU0PWBD6cJEeUT6Xc8OznerRycOp5TreOwhYjT5?=
 =?us-ascii?Q?ljDOoHJeevVAdRJbQF7KCMykUYc47GuROvp7ItB6LJyqfKGqFS0LW/FauVks?=
 =?us-ascii?Q?RqAwbKwZ3I07/vnNtSgyejITRWMgFxdgD8mBpDeczQ/ZotjWFkrMf2xSBzQ0?=
 =?us-ascii?Q?83BL71FO8ss8h0/vDQqAOYI9h6+UAlqDLMdbTEJjPzq26+UDR9MH2UcR/+yF?=
 =?us-ascii?Q?wTxtP/l8Kc/HjpAURw2khMxe+AYKF6GdnCBaY53TL4oQhQyNubRoTfc3M8hI?=
 =?us-ascii?Q?3C9pWZjgylRtmyzKSlvJpshz0Ndh4U+wibTY9FckJSswS+BNyulVszvTOi1g?=
 =?us-ascii?Q?/gY+3jsmUvKac1X6JZsb72jM5MUNliFIdItCOQIRXRLmQfzkr8ucceT1dMaI?=
 =?us-ascii?Q?a9lErKwzsw/OPXFpH9Kpx+Ub1JhAjJMUPybK1D0N2522Yd286KXTn0TtMj0l?=
 =?us-ascii?Q?jxUJrUjR4+1Lxn6fDdWBNSTL6hwvx0fMRfO78QgLvZwlHMgpXLOHzgri8bxQ?=
 =?us-ascii?Q?1rmQQ2X/hxuZYaRB1OMfmP7RF/x+5/6Jd19es2wO3U0dxn06ZlLIyt8cmnyT?=
 =?us-ascii?Q?b97EhpLO9+3LHDTVPyvRR8tWjFmHGggU3ndwWzpWTlXOGXDv4FxMkgrAwp9p?=
 =?us-ascii?Q?/zqnYMtapAbsYtrFEIGToMeAGaepC+tdRi/nXcdVikDZFAWO0+2A3rR127G4?=
 =?us-ascii?Q?jFOLxA1G4TQXLSXTR/khzNiOjSur2QVGukdGIdWeFKr4PPmYoQRN80BqgrNM?=
 =?us-ascii?Q?pi0xlEX8cMEuY/PTVd6ioOLC+2y10IfGmuREQtYNyIWYOsP6O9b4aHawpiOi?=
 =?us-ascii?Q?ystb5g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d31977-cf8c-4df1-3386-08d9d51e49ef
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 16:20:31.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hRleLgZeRxDS4tnIhSEP1JFD2VSfS/6Iy+Wlt2Nc9t96IDDH3Km8WzJcsi3UUJVYwJQxektupS8Jsqgvx1gSZCJ510Dxr95kFO8wzkOKGfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2863
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=751 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201110092
X-Proofpoint-ORIG-GUID: FkVyPF2kmNt8m4r5hHe53udYiG7CW0ap
X-Proofpoint-GUID: FkVyPF2kmNt8m4r5hHe53udYiG7CW0ap
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 08:17:51PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 10, 2022 at 05:27:25PM -0500, Daniel Jordan wrote:
> 
> > > > Pinning itself, the only thing being optimized, improves 8.5x in that
> > > > experiment, bringing the time from 1.8 seconds to .2 seconds.  That's a
> > > > significant savings IMHO
> > > 
> > > And here is where I suspect we'd get similar results from folio's
> > > based on the unpin performance uplift we already saw.
> > > 
> > > As long as PUP doesn't have to COW its work is largely proportional to
> > > the number of struct pages it processes, so we should be expecting an
> > > upper limit of 512x gains on the PUP alone with foliation.
> > >
> > > This is in line with what we saw with the prior unpin work.
> > 
> > "in line with what we saw"  Not following.  The unpin work had two
> > optimizations, I think, 4.5x and 3.5x which together give 16x.  Why is
> > that in line with the potential gains from pup?
> 
> It is the same basic issue, doing extra work, dirtying extra memory..

Ok, gotcha.

> I don't know of other users that use such huge memory sizes this would
> matter, besides a VMM..

Right, all the VMMs out there that use vfio.

> > My assumption going into this series was that multithreading VFIO page
> > pinning in the kernel was a viable way forward given the positive
> > feedback I got from the VFIO maintainer last time I posted this, which
> > was admittedly a while ago, and I've since been focused on the other
> > parts of this series rather than what's been happening in the mm lately.
> > Anyway, your arguments are reasonable, so I'll go take a look at some of
> > these optimizations and see where I get.
> 
> Well, it is not *unreasonable* it just doesn't seem compelling to me
> yet.
> 
> Especially since we are not anywhere close to the limit of single
> threaded performance. Aside from GUP, the whole way we transfer the
> physical pages into the iommu is just begging for optimizations
> eg Matthew's struct phyr needs to be an input and output at the iommu
> layer to make this code really happy.

/nods/  There are other ways forward.  As I say, I'll take a look.
