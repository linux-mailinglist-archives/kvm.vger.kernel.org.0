Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8551A487A9B
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 17:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348324AbiAGQnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 11:43:22 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60608 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240038AbiAGQnW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 11:43:22 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207E0Zaq016731;
        Fri, 7 Jan 2022 16:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=ho+0O9Ed8WPH9gvQIBdhUejrafVjSU7OsV3o8CBdSkI=;
 b=c21JhKv72a0S8+VLYadifvvZqIVBhJfwtVshFSFBn3zC9ctbkaz9Fi+5D/n1QotQGwoX
 gLGb6cy6jJEWfIJcvUlohWUll2u0wbubbjGlZIipMsjfsTXq9OUVvMyD55J5iWeM30Sv
 6nZ1b2Jgn987JXOWA/QNY+o5QWd6UKg2wfEt74ZYcxZ8zcwrttG19XEzMUBsfR9j50J6
 S2OPSO68pdvbOzrK3N1kuhqjB+IGdKWbGfpo9Q0GUBE+p4FCsa2IMmDtSXPAwwfUp9Eq
 yuSMLjz3d4a494n8XH6DcyR80YhMzRqujbU8yd+11IWW/vWErhHY0FOOoAY1/ecuZZI9 zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4v8af3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 16:39:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 207GW5mD195521;
        Fri, 7 Jan 2022 16:39:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3020.oracle.com with ESMTP id 3dej4t0n94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 16:39:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xl4o9DjJl9iVQ3lSJaZtEG2VKnHkeOk24frSCMNBmm1Xz7pDmBc/IgWmSm8EcRdQEu6E2tHTvGrK17cv25cRt7RVHyVv6CjRR2VLCgnBjWdiEsb8EkB5nZ/SyMw8uuificx8ewWPq4941oef7kxXL6aCmD2hYQh6iVhxO7cM6TKrCs0VsNrvgaPQSRvgrsIVVQq1fpX7xERttNDjcu3MaWg7tfoX+u/vpWLRqxPqpS/wIQ874uK375pJQ+bt+N3YLPMQYP+szmQ/Dwd0iTgpjwmR+7WQhzxGmEkY1KQqwyTtN9jr83pPgHQkvlwPIbxp+/neR9yPd8onCypi9zS95w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ho+0O9Ed8WPH9gvQIBdhUejrafVjSU7OsV3o8CBdSkI=;
 b=Aw+vxZf9LHqCdpO/HjaCUESHIS5KjR8UNwJwiSW2gcbqBdRAL5IG1ZwIf4x5Zj+sWaeIiBZEV38LsCPpo8891u8EQkkjw0F0XjWZtuMdULXQhN8O0o3gCOfPx5pvxFkjNEY8/IEJrjBidJv3y5Dy/+aKgsKrkOaJLLglCrTahQoJZWS/QCgt+Ktfa4XUhyNe4yBW75ct+RBk8xdpKg2moAqhUxqLQ0Dp8x0FAApuvzP/LRnP6uSDySD+bj4fEZGZbMEBY/fHeJXpeJQPEsWYiCoW/1WsSfaoeXr8dBnLVZmgVWYxG3EK/tYPg0SXQc9ZRy0RsnEUieLLXxgzfsqBvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ho+0O9Ed8WPH9gvQIBdhUejrafVjSU7OsV3o8CBdSkI=;
 b=Z1vScsL3MF2/61mqt/cn48W5xuRg1eSR0iNpAsKdr02YflLM+/njmapaqy0ljM7s6B69xfzD58gLGEyPs3v84qHewXfeUDIKS4+DfV+RffiGBh7a/IFTvjtcGDTQm6MBqpjeNCIrPJb6GI4Jq9c0Dronu0mQqwy+Owo+kUoHrMM=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 16:39:43 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%8]) with mapi id 15.20.4867.009; Fri, 7 Jan 2022
 16:39:43 +0000
Date:   Fri, 7 Jan 2022 11:39:38 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
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
Subject: Re: [RFC 08/16] vfio/type1: Cache locked_vm to ease mmap_lock
 contention
Message-ID: <20220107163938.esft3w5nscav2gu2@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-9-daniel.m.jordan@oracle.com>
 <20220106005339.GX2328285@nvidia.com>
 <20220106011708.6ajbhzgreevu62gl@oracle.com>
 <20220106123456.GZ2328285@nvidia.com>
 <20220106140527.5c292d34.alex.williamson@redhat.com>
 <20220107001945.GN2328285@nvidia.com>
 <20220107030642.re2d7gkfndbtzb6v@oracle.com>
 <20220107151807.GT2328285@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107151807.GT2328285@nvidia.com>
X-ClientProxiedBy: BL1P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::18) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dca60111-0c14-4145-2230-08d9d1fc4e78
X-MS-TrafficTypeDiagnostic: SN6PR10MB3021:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB30214CF62DB5C6359DCE25DBD94D9@SN6PR10MB3021.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1s6DJnW+vhBWWkcqlYpiUyZWjROSt4yooerw6BTyNZZyG2sCUhDwjO7fhczxhIt0eM2gEfW0DcFCiGDM4D71JOSFXJXgJd+e4QwMwDtNG0fH8M37j4yH4iX1O2RdTCjUyYt9Bjcc335C1gQ5w4n41xGic9T8IGA56Fj1x4C7+rA9DFlKIR2QeqORCXlaP+raDBRP7e5H5XYPM2jK6EGVEo7CORwXLoJ6L3cviY1ifj/9WyhG3lI3OxidgqWhMmF20KHC3RfwkLuAl5DQXHTEbyhWDBwq4DTSzQKOy1X31IzWHlAnOUF2nsKtcoAH/21Jd8KZGMrjnfEy1tsLpjRMERFr6JqEy5L9/zOxZr93e5Vbj6RtB46dicu+RJm6Wkw916G7wI8Of6b6dsr71CHawNsJll76i1GpaFtAU6cwVyIXBnoc7Nz8rj1l0FZwGINvtf9y/gXXhQc8F07rJOlNx4/+oXEO46UPfoCbKSGOMnBTCqarzU8RqlqeaV+b32ec7UM5xvx3n4A/+Mm7W5EemuNHTzixa2rqmhJuD8jFNf9SrED9ioFqXx7KZhdYKR/jeiZHcxVgQlvh0OJ6FCckF0IFac845+UiwnqKj+IzFCLPdVAXDrtP3spOjqH4hJ16CKAwz00CbutDYViYppEig3zVs4JmE4HzUxseb2fJk997ORvbPNbZ6NBIyp/WSHFU4BepQlxkJiMCBnoKiDEUzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(38100700002)(36756003)(38350700002)(8676002)(86362001)(8936002)(6506007)(7416002)(508600001)(54906003)(2906002)(5660300002)(6486002)(66556008)(66946007)(66476007)(83380400001)(6666004)(6512007)(316002)(52116002)(2616005)(6916009)(1076003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dqVqbkqnhI4XYe8WGnBUMDUZLr6PjSmpNqu62WKZyo+51Nrw+iUPXMxkc1lv?=
 =?us-ascii?Q?7gGW5lCoS+XVIPWZM/Qbbl5gnUqEemQIfwjueZWT2OuJbHcq8RhiTyj4mzFX?=
 =?us-ascii?Q?uG7DToGjbhZnHYsdi8pziueQzdGoMFILTj01rEmFt87ZcidfydClUH7ffCFz?=
 =?us-ascii?Q?01frsRABytkN443i1qqQl2xTd9aFH73kRf1F8C8K7FqrgkAMk+SsW1EyZZZ2?=
 =?us-ascii?Q?S4O9NHuREozbk+pPjULvFjIQT9NM/EiH7WFcEBgIMKbAGUMlneWa9HMAXQcL?=
 =?us-ascii?Q?POmcoo6Rbi9fwDRIZQWjThdHP0uKaWVEFeMysEYWTOGCbU7ukEtJkx7PwMz/?=
 =?us-ascii?Q?5BjvTfU28uut2g6HxF5r80NsNp85Bf2fI9AMFUlSCSlSIGQcFJOPwq+1uJAe?=
 =?us-ascii?Q?154b9v0hbpqRu97ChDko23q0gfvQ33GjoLQXSkdGZ18umHeVXorMLO68LpGD?=
 =?us-ascii?Q?u8N7VE5oLqb4FFD9+ccFosQ5Jk+TfzAra7Dh4uFuV7z7aoa4AFUq1j2DxH4g?=
 =?us-ascii?Q?6YS54xt5jsClIMCFCzSkCW3DetrXXmg7xbQEdOsNrXaGJTMqGZOgnKo8sNmz?=
 =?us-ascii?Q?5XcKmqrorzGLaChlwvP4khNr/EnFSCHN+6gTteK/KTIcOnJylV22dEHo60Kx?=
 =?us-ascii?Q?rHvMJb5kYpOn/LBWs1bWck0yH8193whZYaSc+Ffa4qWE2e4odQLbL6DrA+lp?=
 =?us-ascii?Q?9niphFbfgEN8INFS1TRGyjPHGJcu+yzuRkKuxot6LKY2EmtbTvUJgkEJ4MwN?=
 =?us-ascii?Q?MK9hZ54Sc6L4GZTSMKPj1gz3PZgXw8+HjMjYkgNPsc2zN5G0xYdhx3vDlqyf?=
 =?us-ascii?Q?2IGCUex88KiOzGCYX1TFOPqT5kM+3uKGQKNUX6P63AkCyt6YceC+rAuA+Ifq?=
 =?us-ascii?Q?+RZX3koaORothou03Hc8ngWiYvDdt1PgLk3q/d/ZaXcQxOzeaorVUcxM/4BA?=
 =?us-ascii?Q?e+C67kptipK0ua76mrru9cKaoyXbw8vc1dTYXJ2bHKdW2H8wB8gisPoDd7Lm?=
 =?us-ascii?Q?H0FFwkce0uD26dmDMuhqB9+HRlYyGp7ljwG/OyDadPdQz3EAI92ETnwf0cvc?=
 =?us-ascii?Q?BJYICNPoQSjsMv5qx2vfOFHuupoEG+knEFjeIOBLKvcb4G3xE/zHDj7HZYFx?=
 =?us-ascii?Q?AUbSc6ASUXLfP2ynx1D+kr8pzyqDKVa+L3FgYygK+q3HiDtqeba61nIyPcDE?=
 =?us-ascii?Q?afCihw4NEiZtlxzdHIaiVxenyxGGe6GG/p/xVVY5Jr4a+HSdFnOulJoQM3pC?=
 =?us-ascii?Q?PGT+nmh2UVeElNJCJzgVu7+Eilrlu0eKMHp2kHvbzMJAOk5bJsfo90A1gNUd?=
 =?us-ascii?Q?2P12JzI8sd53AFhxdhIt7wnJuDTUaXQnxKf5Y14hR01i3qA228SCbrFfsx4O?=
 =?us-ascii?Q?OdfMwZGSWavLoWwkN1yeaq88gbQBc6B4CWbLpuqMINZORBvNDeziwFNGyVnw?=
 =?us-ascii?Q?xcL+8m7O9DkdrD10PH5Uk0jc6kIYOWRRcVDgvgY4krh1QPDC5uoYfYAZGWGX?=
 =?us-ascii?Q?gCQfFntYvff6D4itLKpmP0KPFpy1/0XmmJ0fufaqYiqBrok0y0vFOSdGHzs8?=
 =?us-ascii?Q?b28WyXirJOkgm7ZBCcQbCNo7UbKlX+BidObDcskRw94FejmIXC21e2D//+aC?=
 =?us-ascii?Q?4rSxgeKaZRUh2VKj7RIiC8kVSIw19byuwrSjwWfrvW+NB888myuTTwRqEWEl?=
 =?us-ascii?Q?Cnen6g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca60111-0c14-4145-2230-08d9d1fc4e78
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 16:39:43.0750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/N19XvDI4Qn9ifNamA+ADSOrrivtineeRISLwvWF2CPemEGsDVf5C6WD0OgNJHr7xGdY7YUPGoLCVHe7fnXHxOsDIwq/KW1rZAyta7yqRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3021
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10220 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=811 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070112
X-Proofpoint-ORIG-GUID: 4dAnZtV2TB6-tljVcb2WzXvK4Yb1tKNo
X-Proofpoint-GUID: 4dAnZtV2TB6-tljVcb2WzXvK4Yb1tKNo
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022 at 11:18:07AM -0400, Jason Gunthorpe wrote:
> On Thu, Jan 06, 2022 at 10:06:42PM -0500, Daniel Jordan wrote:
> 
> > > At least it seems like it is not an insurmountable problem if it makes
> > > an appreciable difference..
> > 
> > Ok, I can think more about this.
> 
> Unfortunately iommufd is not quite ready yet, otherwise I might
> suggest just focus on that not type 1 optimizations. Depends on your
> timeframe I suppose.

Ok, I see.  Well, sooner the better I guess, we've been carrying changes
for this a while.

> > > After seeing Daniels's patches I've been wondering if the pin step in
> > > iommufd's draft could be parallized on a per-map basis without too
> > > much trouble. It might give Daniel a way to do a quick approach
> > > comparison..
> > 
> > Sorry, comparison between what?  I can take a look at iommufd tomorrow
> > though and see if your comment makes more sense.
> 
> I think it might be easier to change the iommufd locking than the
> type1 locking to allow kernel-side parallel map ioctls. It is already
> almost properly locked for this right now, just the iopt lock covers a
> little bit too much.
> 
> It could give some idea what kind of performance user managed
> concurrency gives vs kernel auto threading.

Aha, I see, thanks!
