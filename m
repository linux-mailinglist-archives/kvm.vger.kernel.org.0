Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E502848DF6B
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 22:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiAMVMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 16:12:06 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46652 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229931AbiAMVMF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 16:12:05 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DK4Jqk002522;
        Thu, 13 Jan 2022 21:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=J0lMxgO0tk/sNNh7/Ec3xRf8SBy94LwZiY6zG5s7oqA=;
 b=sHyq5kw/txcT/GmxqiE+tBPKS5STdxx76abJSkWQZuQBSkbhy1IelB2u+rOKnt17nmgp
 m6Gyt28F7bgWBwGcBbIvPLJdbTyIF1hVef9kOszuhJ+UrIWkBeKMYiVi5hBOQb28SdC5
 AsR+TiitwXsj09v5h3oy3CwGC8Y7DguGCjp3TxBq4EHUKUmRa948zJLlXYT2j/yxaEcq
 9SKLT3L7Raz8UvBkjuyJ8ZBRsLLv/kuhoT1dU9r06Y7GwHQeHAJ7b89KE/vfXRMTQ3hh
 O4yinsW9jSZ4qcT1iKjlaiidioJxLuBjUj1zb0nTroJ0071jwcIVa4eukN9IvslsfQrn oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3djkdnsw1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 21:11:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20DLAaOW017951;
        Thu, 13 Jan 2022 21:11:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3030.oracle.com with ESMTP id 3df0nhmp4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 21:11:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQRJDr3iKHOqEgWNMi8OTtGY5dbAzjp8ilSIbIf9qFxg4tKLarYNtS0Xid75Ub/rXPxa5FOOSXT6a453UwhxGXSBD2neXmDPulWDxhNxU4Pmj6VOUeCHBLDXphFiqezF44AqENO1ScKFu86sUvYczpPqeqF7NHG8Cg5I2yjjdqddYqljDeZNVBkdMoOgFzg01HKDYgSfeI9Ao3pgLNzgI2qQ7E5BmpJeMG9e7Z/SldEFmpVpCa9APCtDm7m5CJD5Pg95rGU+vRTqYV8vTkMmN+PVRqDPf2FowxhZYa/hZb+Hf+xlhb2YsHwcUbulQ4R/tV/90H30wg2ZT+q9TYMcYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0lMxgO0tk/sNNh7/Ec3xRf8SBy94LwZiY6zG5s7oqA=;
 b=JzSMZa6EvT7FaYBVrK00tmZ0M9uva1MX1Db2yFvQYdrPc80dom/aOpDn8WdrLJ+zI3rDny4NQxjLdxX/G4Dzm7Xll1DO7SADpCyuOBGydN0FJYrFrxybS7EQlSb2prbkYM2PXGgjX6rBL37ujKFttetJ4HKL1nPKqlqyNlM2NhD8MCflyr/0SmPfDikbEXegAfcOq21mocwOQPwPcCGGMWrPhOSkiovWAS6sv7c14MwlzaJhV3RMk3qguW/u8ydZFl2Ge93PKM63VQqRrBe1LkOuHH4UFuv46chxyvPnEsi3z5ZgE1qwuL4Apalg8UHQ64PngFaFA2v8b9g9xwF7ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0lMxgO0tk/sNNh7/Ec3xRf8SBy94LwZiY6zG5s7oqA=;
 b=FDo5Nf/90YCxfHrcNdKar2SfPKQKvLQ+AQcwkL17xqXgPuSLWhTVojSwhlnueNmW6leKr6YsSZKZXaURriCfEZX/X9MWQDjV7Q+Kei9jzUaQa3jqmgeb6Qiv93B6graqYbxlOm5Gvkwy9YNE8hxdsuISV1r8V5ArLF6Jwy1vURQ=
Received: from SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 21:11:28 +0000
Received: from SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e]) by SA1PR10MB5711.namprd10.prod.outlook.com
 ([fe80::9d38:21ba:a523:b34e%9]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 21:11:28 +0000
Date:   Thu, 13 Jan 2022 16:11:23 -0500
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 15/16] sched/fair: Account kthread runtime debt for CFS
 bandwidth
Message-ID: <20220113211123.c4csxg5srmkisqwr@oracle.com>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
 <Yd1w/TxTcGk5Ht53@hirez.programming.kicks-ass.net>
 <20220111162950.jk3edkm3nh5apviq@oracle.com>
 <Yd83iDzoUOWPB6yH@slm.duckdns.org>
 <20220113210857.d3xkupgmpdeqknhn@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113210857.d3xkupgmpdeqknhn@oracle.com>
X-ClientProxiedBy: BLAP220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::19) To SA1PR10MB5711.namprd10.prod.outlook.com
 (2603:10b6:806:23e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53c66d97-60cb-40a2-4b6a-08d9d6d9437b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB56126996AF0A8A6EE4A071E2D9539@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0ySfv4axtGANqmYMooO9etmUy9iNFyLcelXyZOjnsfi3ywtNxITXdrUICJFL/4rsIXs29INbXOwbpq0Eeh+GJsmGRVrU4w5hLL6ZuGRcThHEELmzJb1gfl2032maWruyman3qJomizZaPDYyPkDhnA5nbQyhZ1/XDdCWUb4w1utiW3p0mN96t97PNLHqH8NGmCitOEf0B8M1h5TA79fmN4BklAe6WsDG8KKcf6pMcA4aitWT+hA75jly+FZH8xMaNelAuGxujn1S7L6Gfg3qQq+rxvN8qCTGIwbSOJnvYPJVHu5WLvXm4vsH67PqO5ZD3uk35rOOPfDRkzq30fGEOofbNZ4wRMseTU1ux/BvkHfhr7JuiCJClOYEnu5gAIP0kcRehFv12eikbZGV6tBUFRtbDLaJ9jpmf3g+AH6sNA/PBhyB1VhvBL5Y2fx8cJInU1s53is4pwYE5+7RiOOygC7SjiPFwHHjnr9ys5K645mO4f+uQadTa8iipnVrwov6epgaaXKZhz+4BUQ7ZU834DiCUnBa0lzrgR7TqjQj1DEPZohOxkUYdrpao2VCf0UuaXysDUhwnE9RnXeBDlJdjZsojdUG7KR8bUqYWHLG9lnbQlZn1grDmRT5shck5hRZ2SA4aQRtiu9hdIwTP/FU5CGPD4dIZ8HVndree9fOwPfPODdWAqf6sDaAnY/75SRs62NbgmUOjdPx2JYVAtJEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5711.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(26005)(6512007)(4744005)(4326008)(6486002)(508600001)(186003)(8936002)(38350700002)(8676002)(66946007)(38100700002)(66476007)(5660300002)(6506007)(6666004)(52116002)(1076003)(83380400001)(316002)(54906003)(7416002)(2906002)(2616005)(86362001)(6916009)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8z5m/dobTHNWyPQ8dkVS2GP/u40aTOfFj9n1oAWKBV/XLJf3E1S0fCJTmae2?=
 =?us-ascii?Q?FhdDPb2P5bob3VD8S+LVH/1Si0AUykg57OjWzNaS2oNBFyltXY0hv1LH3JRN?=
 =?us-ascii?Q?2pd/GRLPNX86wf9MYKxRAdqspPLinC6z7h5aDiLytXuwYbgx8fgtUSE03l/s?=
 =?us-ascii?Q?HE76aVeeEGCIskVPS8Ftvw9PSdFVQ+1qUbdVeyNfv+ocyDsumTBn1vcFyPCw?=
 =?us-ascii?Q?tg119jaqp8ulFSrYWmh4iB5yJwj5848+HdLvD36BQQ/rjWILu/Eos9ljTNbN?=
 =?us-ascii?Q?SmzpPA64NdQYvHi96r8i9uLutrBAczS78el2JRF1GRpbSQkwLrgVMY3RM7GP?=
 =?us-ascii?Q?3ScU/gG8za4WEigEy3tWzo1jXm7sSidYkequDHvLbuCo5+TL3in1o3LOgkSi?=
 =?us-ascii?Q?gX3Q6Y/Ag59/0WjM/jCIRbPqnyjCiNtCKeoQCD/zckf6+O52ovAwxsqCysDJ?=
 =?us-ascii?Q?TvZP9ut3n6dWBKl9DL27//E4d2bl3HWec2cYWFgK2SkI1UJgHpKJQGHwvNPK?=
 =?us-ascii?Q?Jn9eObJiK3D5eah6mblqgSZ613BkixAQTpfF+jsH32wN6M8CBPoP6S5ZsGsB?=
 =?us-ascii?Q?6dtrOSlBQerZd6F8s87syKfV5Ur5UmYWd3tf+EkDza1o08iNSaWtrdiiDzAQ?=
 =?us-ascii?Q?yAVM427zcvAE+DwNk0D/2xik4NFrjZoJSJAmkzbMywo+Mmwsns+XJA0Twcp6?=
 =?us-ascii?Q?sUVzDQcngZhtKxGlzFNa9j0eMH09V9aHdiV7mR58DVipQU9tQZI+WFX7hrDG?=
 =?us-ascii?Q?P14Sr+iQHLM/wwlFP8j/iMYb9lOoSEhyNIYhN2FMlYgj5+v664178giCbtCS?=
 =?us-ascii?Q?ftxjPXFzdSFr+Jisp/jKlfQCtZN0/r6JVMrlWV5TSsaRCiaWtLF5myCPXEMY?=
 =?us-ascii?Q?iWPj6WRTG2csl1BKmBRUU+ycCzXs5BjMfIEsVIK1kAVq7ovIek5lbnev3EkS?=
 =?us-ascii?Q?idOKtw6gtkganBES6bRVJfu6npRPtm00zr8Ps1VtcoTjbBpuEKr4/uqwqDtV?=
 =?us-ascii?Q?S20vxzn3vdBN+AzXXXiwQVkGGo2BTd5atsCSstlW8v0wCC2ZnWTC9B9CuHGa?=
 =?us-ascii?Q?M/IhPDIOU+kok+HLRWIdU07NrBCPh7IaGx8RJR+YTb0zNr/SrZdamZvKRWde?=
 =?us-ascii?Q?MNIcuqY2YckncK5SmBdodn2bajFl+YdXW6cMB5dyNXvB6QY85VyisC1Bh675?=
 =?us-ascii?Q?TeZxMZvOK8O5lIzYsipI8bdUlQedFhk1eKS78Xl7vNf4I7R5O0K6X0E1K74t?=
 =?us-ascii?Q?Dm2UM5Ol9xqjpVLYCpz2qgAjTOjxUC3XIAc3BJBquu4FuifnPEH9DiRQ/gg6?=
 =?us-ascii?Q?IyueBQcdNhgVb7sp62FGhuoCk5tduL8p9KR441LPkTQjz3kBMcQf4FGbb8je?=
 =?us-ascii?Q?olwDkyUtLY885TN4jxdFHpmbdhLK9HwFQ/Kw//4AuCBp0MWC7JtrcM+nqYUX?=
 =?us-ascii?Q?3qeduVYWKiUIuFakmwTWiy/i2pPY16kK8rpXe+EWUyaARW4mTsMnuSp0gSRw?=
 =?us-ascii?Q?y6ma3bat1sSU48ujgtMA+S9LJLHwkLioyIbMpKJUwtJZPv5FMRvlmWUq0ed8?=
 =?us-ascii?Q?34Ih0lb8fI6oc0MCu+ZMmly9Mo5u+auvf4WdP78+0qF9YzZs1fRxRy7JhIQt?=
 =?us-ascii?Q?G2RB2buP3NzYqd/dFPrX5sE1sa3FijKXKKXBPJLpl4KDretQzeZHxq6ea1wa?=
 =?us-ascii?Q?i4pUZuZg0lr4RiGMR1/PggwzaH8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c66d97-60cb-40a2-4b6a-08d9d6d9437b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5711.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 21:11:27.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oRVe9g1VnVZ16sKWVFIQscPBb+/6/ztnUo923BeRwsDbGCwY44IhipEVDftJdvcojzgtB5CQui9GcOYxoEnoX/UOR+tMXpLO3UStS66FK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10226 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201130130
X-Proofpoint-GUID: H5PW4-w-ZZaaSpH600va4HadxVy6ZcEc
X-Proofpoint-ORIG-GUID: H5PW4-w-ZZaaSpH600va4HadxVy6ZcEc
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022 at 04:08:57PM -0500, Daniel Jordan wrote:
> On Wed, Jan 12, 2022 at 10:18:16AM -1000, Tejun Heo wrote:
> > If we're gonna do this, let's please do it right and make weight based
> > control work too. Otherwise, its usefulness is pretty limited.
> 
> Ok, understood.
> 
> Doing it as presented is an incremental step and all that's required for
> this.  I figured weight could be added later with the first user that
> actually needs it.
> 
> I did prototype weight too, though, just to see if it was all gonna work
> together, so given how the discussion elsewhere in the thread is going,
> I might respin the scheduler part of this with another use case and
> weight-based control included.
> 
> I got this far, do the interface and CFS skeleton seem sane?  Both are

s/CFS/CFS bandwidth/

> basically unchanged with weight-based control included, the weight parts
> are just more code on top.
> 
> Thanks for looking.
