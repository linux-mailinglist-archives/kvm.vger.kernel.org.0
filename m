Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC4246D11F
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 11:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhLHKhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 05:37:31 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51460 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231808AbhLHKha (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 05:37:30 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B88xBK6003034;
        Wed, 8 Dec 2021 10:33:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=LhGGO4nhGKCvvb125NIPpOHiGBbHTZKOeBaPuPEYNAk=;
 b=MVJDD8nuuv52PYS2Us08SlysOj178RpUd9ejl+UkxrRbVM68hVP705DFrcPL33P6b85O
 jxoVWjxvzr1G+1TIKviTs0z5MrTvwEfHKLvRyKy7PFxVSjToxUkI7CgX0Yy4h/0k6OoY
 x3cdc6sTLDTBtnBlT0s0GQKfMl5NSn3yUJ5OsZ8AAjNIQBLjibR00D4vHntll82xrPR9
 kre2PxAYHaENOmQKpgwDdkZ9mMWjW8esDwc87N+xUGnGK6AUAPqRRB5MJdBnP5rnxsaM
 wJOeqN9oNmgA9laLgUMLAkYsAQMOV4aLxbCif0y4Y3ZSdL6JpUEQj+CHKOZ7BNNFJ5dj 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctse1g96n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Dec 2021 10:33:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B8AGiNJ035655;
        Wed, 8 Dec 2021 10:33:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3020.oracle.com with ESMTP id 3cr1sqgxec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Dec 2021 10:33:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/hQ+3CcgmenHkPO3dgjUzmK7tI1OoXdefTSP3P8vgRNeee1zMUmM7tswR7Vi2wpkORyGUqLioeCLZP3Ev4XDG4WRu9rvI23sIvwR5+Ax5Jk3CZ3PjteGA4zi5vseoDzCsiuPgk+vVuqqbg8P9ed0TGR1XLw0FcQz9/CdyBb3oc9StiegOkDucYZpqGTFsy8bOmdo/vgE/tbRGV8lEJB5r47A58nxxc+lt9WshM88Aj0WJ9ezv4N0lIzC2NtNMzbBrJ8xgFhIA5y4JDOanaTfYjKY+o/lUkyndza0mU6lJdO/m5e+68bFcxiEmwX8OWQGDdaUjvvhirQvK4hhcW+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhGGO4nhGKCvvb125NIPpOHiGBbHTZKOeBaPuPEYNAk=;
 b=RyoS5NdhnHWdeAgsISl0Oo2IOo2HAGduvqY2YnSLLdg64qlpkCjlytDYwdV9SAlaGxaCWxINa8IUH9pamn5v1daYMTJmGCFS2llCjGxLJJejRStQM7e49weaHlkDLpclVD0T2axejPwwFDvS8vO7LcFa/jBqWmOIHJhjXcvIhlFNaF4U/gQvTaYESzd4p1pbmltoH+RmUl9o073jVBqO9rU7/hXHqA6X5FwuG7O57W5Y5BNavgh8lgjTj34kPCpWHbCS6Dr/BMa9OwgJ38xvUjpuxf/U5+i6QlQ7EZ33OALf9l7ydYv3bGoQkFHrScAE45kDb+EPhDca1/tmCJw/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LhGGO4nhGKCvvb125NIPpOHiGBbHTZKOeBaPuPEYNAk=;
 b=zY4hTWc68mbP4KV5DnYod7rEwWHCbV3EyYGtHAyLs3sHxp46UfBdkhzPrs5MS8XdOR0L6MKDw50bDYNQAtilMp81MIQ5ekABIUgXYCo4P5h8jV96ex4diWfveMyDWPFnG1FOGS7ACV5wAK46YD4T5idb6euYcMpach7W6AdqXHE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1616.namprd10.prod.outlook.com
 (2603:10b6:301:9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Wed, 8 Dec
 2021 10:33:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 10:33:49 +0000
Date:   Wed, 8 Dec 2021 13:33:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 v4] vdpa: check that offsets are within bounds
Message-ID: <20211208103337.GA4047@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208103307.GA3778@kili>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AS9PR06CA0100.eurprd06.prod.outlook.com
 (2603:10a6:20b:465::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by AS9PR06CA0100.eurprd06.prod.outlook.com (2603:10a6:20b:465::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Wed, 8 Dec 2021 10:33:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49773794-9b8c-4621-a064-08d9ba3638ed
X-MS-TrafficTypeDiagnostic: MWHPR10MB1616:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB161629F3B11C74D4B2AE8C038E6F9@MWHPR10MB1616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iyf8zTesnRanw+vQdGBFls3k6JyBi7m5rnO1ZvsPvR42n9MAd1lcLKLc9jP3RoRAzmBxLdDaJLVN09sliJ3C4yxH6f+d65ACU3chQky2m1heyMN5HK7pmD7XVeOPQuTgRhU5ZXwD0bU4YbA0UwQVngOuOBDNq6WA3wb5dNqteEpxljBKymmjPkeQnq2ssLbIKvAa/EU2lOErT8CEZpgFkqGOExBTIB1TemLzXB6HKjK6agKTAlkpUbw0YgpzOqcdQIbjABcyUnmaMe258fg5liB1qodNPyHDEf4k1KcWExYeyYIvxTBlKnSk8I72SIpGIdsISSYssaScOrl+X7iNydLXFtleRZdCJQDivbjJsioWdzO3dJnyogC4kDLqGhlEoIjLQeEvh4UvNqKK0aVXikZoYE4VNKQmuUzC/P1SuhHaGW2x7mFk0K0vtq5KBk9O4o2wzUGFwtMtG77ebiJB/EII+U3AodSXfI6ShnqJgeWYz7geQdJcYEn7S0IljsEx2nlldTKNCI+DIs4U2dVl/Tl+Jagmmw2HY/xa3v4FPQQPJta9hlFjgVIufMsJag+7TvxzOFsoX9KzCP4/t8lEMQB1pM5QAQZ/IuC8s6FNdUZV+VQBPPkfmqGdVXe3EQOQ7f8k7hj4MrrACfT+PyAJYrEPrdY/A+vw/xuGNiICCebZ5nx1PXUqzAgeW/DWFKEtx0qX7I4SLwXw6HjNhzinDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(33716001)(83380400001)(66476007)(316002)(5660300002)(6496006)(55016003)(508600001)(66946007)(66556008)(9686003)(4744005)(44832011)(86362001)(956004)(1076003)(186003)(9576002)(26005)(6666004)(54906003)(33656002)(2906002)(110136005)(8936002)(4326008)(8676002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zaggBZPCdSrnoivGNzBSv+vSDFNXnm/bDyu3vhrEExg82R28BdO39g4mF3b8?=
 =?us-ascii?Q?oVnhf+Z0p8SZeRb/NEyaBh6sh4rDjH8kQFHR9FbotZHKNnir2s6jcXF49+H0?=
 =?us-ascii?Q?7lsz6rQr5lKznphjHKIrP1ZPmupFoARM1Q+mWrdyS+hccGSDqeZta4tlWc0z?=
 =?us-ascii?Q?6wCa0Iq44YWbrMEsWKHD9mRvGXnNWc7Q3Vmgodf7yWdeObDkxDr1a6R9+8+g?=
 =?us-ascii?Q?2SFFAFo65SZn3buIUWTbqNHD1TX3AbYw892AenTMpD30Z287q1+V6EZsoa1r?=
 =?us-ascii?Q?J8EhGvDT+1oDdcPPhL0Jzr4lP9Dme8cXD4xvesbsUU6JGOexctL1YfTlkhGv?=
 =?us-ascii?Q?UL8rBOx3sPesvTkFxKG7afT5VIIUxBCDd2HIAgHv/AroOMVIX9p0E2Hli58b?=
 =?us-ascii?Q?IY0lJmLtQ0BmwMsc3YhGns2EFtryKXVTMX/EkVTRWSBBc5XgTgb5dAXHZ7rs?=
 =?us-ascii?Q?l68K2DppfXr8cwJlWVyZv5v165fo1pmy7BkLbJFpwGd4PLm1+HWN7GGjG1kG?=
 =?us-ascii?Q?ocnJPaqGp0S41pJKj1Kost2jwbnZbkdCB2GaALO75CYhZX9ru40WhmBAox6v?=
 =?us-ascii?Q?O+6wnC+wHgVW139fJyhzROtzguiO6esp4FA830ieanNU4gkkZwsdL/eJNWmJ?=
 =?us-ascii?Q?J4Amr4LzypBPUwTo0NJwVO7zFZLWVYiOiv/n+83HM+yL53+ick/91EGNETMK?=
 =?us-ascii?Q?2NjgWbGTAZh/i4remU+5EnXniwzdb39D76KXLqgr0RVYT/HhP8bXVMUSZvOp?=
 =?us-ascii?Q?5qlW4ebBwd6CG9TNieHqUJIz3nOdNHjAPrihq9KNjXIz7dRqg8XxZAZp9EqG?=
 =?us-ascii?Q?woXgUzABuik19TtvtQXeHTV+ue0HcTT1o43icOGXxazCvGWylAAN5voiHlnZ?=
 =?us-ascii?Q?YIVggqqJn+F4pmkN6F0MTqP/aSrprmioeTK8+jK04TL1f2WCqj5WeDXLDr4P?=
 =?us-ascii?Q?4wmuHuk/x/37NQDLtmHEvZQA8uJodeUCrvgQ68Dwtthn1aWWRBq1TILuWRVf?=
 =?us-ascii?Q?Pzbs728Ksd5EUVpdyWH4GCGmkFPuhdrAj81UP2wvgyLvVNGUrolUVKtWX5Sz?=
 =?us-ascii?Q?SbfA7p+egHzUEFIaDyEfCpqwE90AA7YFjqMdD778PcpUqCp+64Qc8NXP+4qH?=
 =?us-ascii?Q?a3KZcXiZK0I27d6j16P8fmcaYsaHmXBxA+v4yp35uH//SeQ1Y/hriivyD65d?=
 =?us-ascii?Q?L/3ZRG5KGmgg8jPM4tO+Hz3trYqPBc7MUuT0g8BYvO53wLbgGJvTusO0CPBY?=
 =?us-ascii?Q?govD1F+NMd98jRmM4seZu6YwTeY5Cokv4LG9nJwafNyGL1RxV7zDj3fQgftF?=
 =?us-ascii?Q?GzBg8ypQga6mffO9K9ba4LXviN7i/6IiNNTc7VfEeNxTBzEqZeEKbCtgYJ2D?=
 =?us-ascii?Q?fqEbV1sUGN3MypjV7hnwFGAJy6qNQ0AMJgWL1nDDis2Qx7Hm2s+P09ba7Cgh?=
 =?us-ascii?Q?UPwDq8U7BK3a3vQADhu93s3GYs8gJcmi3tMmU5MZdsQzqo/Emn+uI4LmIOiF?=
 =?us-ascii?Q?MA9tqjiS50swHNfFD/SC4gQk478O22YX62aG80L5Xa8D4vYy7OMdZnNOEdAk?=
 =?us-ascii?Q?toeRcIzcNb1UW3A5WrLS7N0yfsBVPvw908tuuMcEdZZxy9fQthXT4oMbS0hX?=
 =?us-ascii?Q?HTWQrBN+CMhyrFJlRG852L+84CxI/y/aIRVgA8szKsILFSyzhH4jWnmXcIpI?=
 =?us-ascii?Q?BU/a5wfzXDi40NWHWFtYbD7PDeg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49773794-9b8c-4621-a064-08d9ba3638ed
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 10:33:49.9131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vg9t6PSQNagqSEAMr0L2Fll/utGmKsDP59NHVqQkxYXswhlH+8ByvdCPnVQkAKXRoo9nuYPoihO51fDV0h3y72wdWpxncilyr8BPrsXtZBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1616
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10191 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112080067
X-Proofpoint-GUID: tCdQdUwLZkO45dQVL3JWLN6BY9xkoHqN
X-Proofpoint-ORIG-GUID: tCdQdUwLZkO45dQVL3JWLN6BY9xkoHqN
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In this function "c->off" is a u32 and "size" is a long.  On 64bit systems
if "c->off" is greater than "size" then "size - c->off" is a negative and
we always return -E2BIG.  But on 32bit systems the subtraction is type
promoted to a high positive u32 value and basically any "c->len" is
accepted.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Reported-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v4: split into a separate patch

 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 29cced1cd277..e3c4f059b21a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -197,7 +197,7 @@ static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
 	struct vdpa_device *vdpa = v->vdpa;
 	long size = vdpa->config->get_config_size(vdpa);
 
-	if (c->len == 0)
+	if (c->len == 0 || c->off > size)
 		return -EINVAL;
 
 	if (c->len > size - c->off)
-- 
2.20.1

