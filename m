Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133CB4757B6
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 12:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbhLOLY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 06:24:57 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52288 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229982AbhLOLY4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 06:24:56 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFBOZbM017494;
        Wed, 15 Dec 2021 11:24:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=ERP9buCYfl2wugp4c9GPvS2BhYMsdRYYsmmMvN/5hxQ=;
 b=kCRMy2fn5BGXRvxNZ4Po20+RK6GWqX1ZWDraFhZrr6bP/yBW/e51OdQJjZdtR1VYMIcU
 wKZxTLtQf6EWv8wgiDbDnrlTChUHSMCYxePw0qfwve6OofjpVOmI/QeZwVChX3bJ4aZQ
 cPbigEnMyE2FAAD21P5+ouBXhDJuEDBPB6U7QpUZTTw+JYMZd9+r5E0S6inaqWoiUFmd
 UY5tJQ6uFdksUvdUhbjozh5GsWpueO/1ui3I+Xos3cLTLn4mTaUBHEu3ZWKLwumCFBXA
 YuaslyBI+0823Et6DzTVFAkCzcXaoh6Bc0t17ob8qj6oNfXVFliJsBKvNxQQK/1X4EmS WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3ukehjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 11:24:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BFBG6tx003438;
        Wed, 15 Dec 2021 11:24:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 3cvj1f9h5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 11:24:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/a1ZAKyoz7/LvcD89p7xqHLkz0EvPiZehywz7uaqgrXiQE0iWR1pZEucMyj3EeMxAXfn1FOEgfFKI+2gwnWQztDy7gHBrWeSbhlwoe3E0OgPPhk1giLkymjERxhvP/PW3A/weZg7lgKv63Hqfut5U+cXQFMANYnIhW0me3PS4stQtH7RLmIR83SNEMfbYdyl5UZszugLu4gpGDx9n0eIAQdMEl/A5VO+ODu4NfEXxMGOA/B6ORMrJRWqXrcTEv6yr8IaEYYVfOBI0tzsJXyrOnfk4KgoxzQRtPvtzZ/BeU8BcBgbrh3a5xN9hQPw5yv3NSpsU7BDF74/SpjY5xlsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERP9buCYfl2wugp4c9GPvS2BhYMsdRYYsmmMvN/5hxQ=;
 b=SKVfPg7onud8hS9//ty+GQxJ/Bb45kRlJJDrG8Q5oXZrlID9SkGuaOr9O1wJBwkT2lQxHvBPfM8i4f9jSYuScAfNP0UlMxZhbV4uH5EklysmEMwXL01GN/1/15RWryD92WXv01TDWljkBhwYk88UJmKUgJRUOH3JyL1p3XEoOUC9wNdagoppJrQe0YjxvtCifYA4mERtpM4NOnDZXmbyJO/sRIamfywPcLifV6M/mLOSQDZi6Yz3/dLQijCqv2+LtkvJA6RW7Qbvbpgy/JGEKLYQGV8vhMymqYCipkPeVhryWqL2LFXoLfHt7fsoqvcf0VTvVDuZsf+yrUthpslccg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERP9buCYfl2wugp4c9GPvS2BhYMsdRYYsmmMvN/5hxQ=;
 b=XNuDlfVA8rmOWdl31wCGKPK68Knp1pFyWUk5H4WhklsY1Y0adZGoDPnIOsIXKzX3wJdj4/J19KlcVh2sEeo9/s+v5yYngNGaDvZ3YUP6Ai/z2Ecfuryl2rLZEw+J9EKfHwu8WHqNNcxw/rkxGl1hKaAceIyTMZVYXI8OHo6vUdo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4484.namprd10.prod.outlook.com
 (2603:10b6:303:90::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 11:24:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.014; Wed, 15 Dec 2021
 11:24:52 +0000
Date:   Wed, 15 Dec 2021 14:24:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     seanjc@google.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: Dynamically allocate "new" memslots from the get-go
Message-ID: <20211215112440.GA13974@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b6265ef-1209-4c02-7930-08d9bfbd832b
X-MS-TrafficTypeDiagnostic: CO1PR10MB4484:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4484DF9E317E64E36281FCCB8E769@CO1PR10MB4484.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:222;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ET2sUe8P113tMMuwk2LD4142CY2D1XhlPOwHvZMjq6DMEqpbblHa7GqGZUqC54dB5LA7v/1lGAohQJQqCRnOkDkpIDGtIWdp1ImAU7TcjCgg8kCkCLFzAeB3CmtRYqbbF6Ijw0R9Y3xxCZQtGxRMQsUmVLcNGpTTXHPt1DzZpYp8v239dNxJgblqYKanXu1LLFMUYhsXxZs8GkiEbSzAh4zO/Z/N2fB8g6dVXTNuRsWkiN9BOAHrMt6i3EMxYtJR3Gb2MDZ4DXoGQb0Mo44BCOx9osLHVuYWER0sbpeiptDwUGD8xd5K1onaUAIugIKpnjX3MZQXGTFJi1u9fxfrkmn+inbHId2+mpPR6QNIohTtD52NBBBSja8Rh7Fl87EX7zbVndmXAqoaeoFsdQlFEKX1D0uo+0D+LScDM/o8jjC3AA134ZcNsMHGyvDZ2Bvc0lSMfQgu6+KPBbb+wloRw8ZpFjbDxXG2vRMkFRtLzJ9rVARE5SQtqhCnZapycSJv7MsDVw10sOaLHEY+JynU5pgelQramEeSoqnXqyPIcOIvlMHC9iY6zG31F6RVkbppXb3kvj/tNR02wYifnWtYEsPMyrty51xRmBOYpHH6w+zVL2haB20M663GS35MKn1nJynb2kvnMyBFqpXNHjkag+bgvdZbbL+foxSZ/DLdpdZpX3/BVpgyYXgE2IsLHpLCwywErKVfu9cSMwvNoiVvRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66946007)(508600001)(9686003)(6506007)(1076003)(66556008)(8676002)(33656002)(38350700002)(38100700002)(316002)(66476007)(2906002)(52116002)(86362001)(83380400001)(186003)(6666004)(6486002)(5660300002)(6916009)(33716001)(8936002)(6512007)(44832011)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0/T+IPBZKIAh1YygkEfvmYftvIFOnM4dq/8XZHHPY6Vf5sNWlCIM37TEgTBn?=
 =?us-ascii?Q?Vb6VfIwCwdqFQ2sMjP+UAdsDmY97OHlhVkpd3UcOCA/OFz3A5b6NDjpig+5Y?=
 =?us-ascii?Q?DGi9/mnFcPX8ztLRAaAwXkurucPMMwSpsyqyAZDL6Por4L/CpDAtX/x4y67W?=
 =?us-ascii?Q?XWfPiHHlzrkhqtJzi51M6/Y3mXNe9BKF2E9yXkA2wE2/NrfxMkhAk+I87ftG?=
 =?us-ascii?Q?rQi5p3Q6Ou6SfDZQiDlyB0UrfmT9JQ5Sy9m5NVl7BjTMP7aHM1IxohfA0SaP?=
 =?us-ascii?Q?YbXIDG6iJEZVyWEVq6UZruee5LnG2MmaVCXiVtSmuSMhlSWum1rCJIIchxsY?=
 =?us-ascii?Q?BeH1m7jm+kxMvQdKyHOCsRqu6haVtuU3U3lXz1x+qCNENGRRBvis96Z9qtxZ?=
 =?us-ascii?Q?IcWZ91dOtAMbklXCpx6k+2PvWtAs1uSIV3pbaUH3c7kT/e91C2wyli3hcIGv?=
 =?us-ascii?Q?ei5SZmKEQ4EjkF+BhCwSvkDBghioYJ5hbdLmVl2vWTQS73xTqatjVe4nkOBa?=
 =?us-ascii?Q?pZKddlirh69YgGz5qXar0nP4RbAmZv7NodJ7gyRd2LkNAxjz9oo4geCeXOCL?=
 =?us-ascii?Q?6qeiWXb+GcFnvb4i/Ygd4mvNnq5/RSIUlab0+WgN6F+FC0iZ3AAERf3IaU6i?=
 =?us-ascii?Q?i6aqUdCF07pgbdok28oK+pE7+HmaRUdzZPTN8QwyIB6brX7VhxfWAwQoyfAe?=
 =?us-ascii?Q?g5BPHx5j5tGKIC/TCKDdv8KqzhZ+1pJT1hRCvVdYvfqznF5QKK1phok9HfNy?=
 =?us-ascii?Q?KlHHcLpERQmL21tAu94cBdC3whiuvc2e8Ervfh9SOzzdwaKwHQF0YK5Gi4e6?=
 =?us-ascii?Q?NNhRbuphhiv1irVTxqb3Fjxr+WxcSKPKJT2tKw3Wwd07yjiNy+CfdWltn6SQ?=
 =?us-ascii?Q?d2LwkNeQxfE16Ki06qQbY8uBU+e/vQRWeEMRR6U9DVrvYhQHIWMmHPFIqABc?=
 =?us-ascii?Q?4iAvYI4IpL2gtdEjBxcrjiZCsi1Ca5kpZI43NB6PPtOu8uYJ4OEq6FTtgJWg?=
 =?us-ascii?Q?PJeMDo9SnaF73DJUlrSvX7VxkT8lmntjl6Hh/3eFTekMJmPu9epm7m1fKrVL?=
 =?us-ascii?Q?9w1GqjAxS1FuQNQck5yB2uWWpOfQN/H08vAtyBYz7LiLMkOwnEysPlzmpUUt?=
 =?us-ascii?Q?a8vbziDSINre1m/HpDUaNFkfjrY02ZuAyNPsmGlIaeliSPExbnfirzdIZYWp?=
 =?us-ascii?Q?5WqHvjEToEi2YbKAEIPop2QCiT6lr89W/GJzOfPYPBuupyMxlofoveALiFiI?=
 =?us-ascii?Q?Q3Wxqdn5hb/KhvFhazcmbLs6g+ExcQOjmvYfYFDk8HxvQBp5sL1MVg1LPHo0?=
 =?us-ascii?Q?Fzd4TGNit2sXUVudh8Zq2fA0w90ZIuXDW4t/qQWCE4rYX+Lh6dHXgXnTPvhW?=
 =?us-ascii?Q?Q7on9rSi2k4cvSoCsMyFTqRNuLdQkgH7I8vf41/2UdgjzIEsJEa1IhmXmKOn?=
 =?us-ascii?Q?4jfeQQ1m42PrETxWPG8TVSVK/kV4yfwhDluenoU2pKjZvS/4g8USqKwV6ddL?=
 =?us-ascii?Q?ok24a0plYyYau2Qh77sSdUqiNNQC+5D55gtq+RG3i6xHc82ifxnGsFHKycOV?=
 =?us-ascii?Q?uviffd2ixSGdEpNp6iaZT8KTRfNutCZfFdRjYqWAba3b4n+qlx/O7PRzZjbR?=
 =?us-ascii?Q?1H5eGhk4BEjSsPYKpO3lUTNEeU6bWCvh5WWLncMPoxgydXOJjWuZNE3YtXrf?=
 =?us-ascii?Q?oY0RluJ7tacQ1NkgTiyAutBO1Xc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6265ef-1209-4c02-7930-08d9bfbd832b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 11:24:52.1043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MfHQu4gPW3jpjyjdpghfLqOEb2MFQBSI/SW4uN6uGbMzShWhFlvPSFcy7v9iupBhuc0/7QFoUvFYReG7ZM9e9VjE2fkS9F5p9nXVtaexyuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10198 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=611
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150063
X-Proofpoint-GUID: cSXx8m7v0UugOSI2Wc3i4zrTrQZqETTj
X-Proofpoint-ORIG-GUID: cSXx8m7v0UugOSI2Wc3i4zrTrQZqETTj
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean Christopherson,

This is a semi-automatic email about new static checker warnings.

The patch 244893fa2859: "KVM: Dynamically allocate "new" memslots
from the get-go" from Dec 6, 2021, leads to the following Smatch
complaint:

    arch/x86/kvm/../../../virt/kvm/kvm_main.c:1526 kvm_prepare_memory_region()
    warn: variable dereferenced before check 'new' (see line 1509)

arch/x86/kvm/../../../virt/kvm/kvm_main.c
  1508		if (change != KVM_MR_DELETE) {
  1509			if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
  1510				new->dirty_bitmap = NULL;
  1511			else if (old && old->dirty_bitmap)
  1512				new->dirty_bitmap = old->dirty_bitmap;
  1513			else if (!kvm->dirty_ring_size) {
  1514				r = kvm_alloc_dirty_bitmap(new);
  1515				if (r)
  1516					return r;
  1517	
  1518				if (kvm_dirty_log_manual_protect_and_init_set(kvm))
  1519					bitmap_set(new->dirty_bitmap, 0, new->npages);
                                                   ^^^^^
  1520			}
  1521		}
  1522	
  1523		r = kvm_arch_prepare_memory_region(kvm, old, new, change);
                                                             ^^^
Lots of unchecked dereferences

  1524	
  1525		/* Free the bitmap on failure if it was allocated above. */
  1526		if (r && new && new->dirty_bitmap && old && !old->dirty_bitmap)
                         ^^^
New check for NULL.  Can this be NULL?

  1527			kvm_destroy_dirty_bitmap(new);
  1528	

regards,
dan carpenter
