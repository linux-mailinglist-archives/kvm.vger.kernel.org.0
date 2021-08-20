Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9403F2579
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 05:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhHTEAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 00:00:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3062 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhHTEAa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 00:00:30 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17K3vEOU009961;
        Fri, 20 Aug 2021 03:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ct2ywHrxV2MDfNLJYOJHpSpaUsbk+WZaO6vByoR8GNM=;
 b=dWPJwk3dROQjLObDRMRRdeom7uM+2ojgSd/poUD4E3qYqsI2dAo3Zcs95XHGm60//i99
 YOci1PhinWuKmTSIRR4tli8pcVW9FzRJKJGmE/GABI/aXLXXbDNUYtVKKkIr0pUQymqG
 sDcLZ8VXb6keX1Sv67w5QiZ3yJKIwSQhb33HOliIDAMiVYv2uZ2AgM9Ql6hhJ536qx6o
 ytiid72iA9lxymjRgc9YyVjyeMOG8kMIMpBVsqwcOu40nCK0CTu2NzrW1mz5FIRgDzge
 W+37IREHHjJoH7BvB25Z96iaBCCMx0Gc9FJZs7vbiyh+ZqZjuBnvWJirOyczzCQdIqF+ lQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ct2ywHrxV2MDfNLJYOJHpSpaUsbk+WZaO6vByoR8GNM=;
 b=XaIQqHclJn5Nh+Xlg5DwXI1fKfxD+38Xv3AXfUwkv7I8SeDVhvsFfysxj/6bLKnFeVTC
 Gq3J7vMvRVtbWdhxL4Yj7yx0mrlx6cpqdkkEUcGt2d6kgTIG00y9bJZWAEKZisZEXmOq
 E8+oN/9EAvBcvEx2kvTl1EPGNtqT6V/Ql3b1zwwyU1wFG9FQgXEtoj5WBZGGviAmIrh5
 k7hc+rzgzE4LyXT8UqcrjLtJFYIaeKbtUHH4glSjPWK4QJAgEwmqk4Qvz4EutlHsndMq
 aVfX/CTQy/e6p3fFUGB7YfB41UzX7LTPU/v/UkPk061H2eIOWblyK2xK/UI6WyYH/EeP Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ahs5cher4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 03:59:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17K3t3B0133821;
        Fri, 20 Aug 2021 03:59:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3030.oracle.com with ESMTP id 3ae3vmsx44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Aug 2021 03:59:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPMmp/c+hqn/5AbLACxORlupaYFaaT6SWIAzk+o7Y54INKBLf+vfszf6CBn11iOPLdrVVxAk1qEQocRbFRcGoiWnKqV1J0AtVqqoTVCHt6f7/AQ/ciRpRTk0ThHaVH8Ba3FppzLhE2R2CvLd5ycNl0HvFLmDBdv+lrzQjY/EJLl2Cv2wwtN9Pw5LvQTqMTNRlwteufph5mJiPgMSMPWhTHGStYWhx5pzxV623ZaOGSmxZ9dH0afJJ19sgFdWo3XijilU4zLeLt3AC7PBJ9rXf+aRy5DzNAGsVwOZ+I4exEuQwZKRgz1piFXdDYtMYn2eaGNZasTNutt+ZLSDiKWJ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ct2ywHrxV2MDfNLJYOJHpSpaUsbk+WZaO6vByoR8GNM=;
 b=aGhl3imG6yBQ9QcPvnqNqceB4WeWsQloXF9FxFlq09fkRINeJg4VOAy7YfTMHN6Zc9/sk/SdMSySvIlamLFF9FUOTbh1ESxf7wtb3/p47AH4lZLfygfbXBHFsKkpXpqTz2SCWCB0wr8G8jxFEIFGh43ELY2sp9g9OH9PypdQ3NA+D1+hh36N16v55Fqut++BtGFcRFcnXHpiors6yg9kxNhxruNSM/xJ3HPw9Lww0n4ckdewdfnu1Aox4FnoiGkIR9Nel5shCiqp8hSFDx6tGhU1nfL3iqSUs/LfWwITyewxuRt7gywWta6g0tGeV6ZJa8RKFCoZSx6HlNKr8JP2Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ct2ywHrxV2MDfNLJYOJHpSpaUsbk+WZaO6vByoR8GNM=;
 b=vN6z705n2p2R4OcQ3HB8h+sho7ca/lVTbRKQ326/GVc5GR+v31im1xVsRJ+8Y0xl1PW1asfg9RQVwZZm5jPkGXj8ecHtxPIRd+k6uP5zBKXdgojq3E3f5ltlMfgCCkkMcxmVBMlBUXIfsCbxsm65Ij7nmOMygEAMDS8m5Z0Dueo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2512.namprd10.prod.outlook.com (2603:10b6:805:47::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 03:59:08 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c84a:b6c5:6a18:9226%5]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 03:59:08 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: [PATCH 0/1 v2] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit} tracepoints
Date:   Thu, 19 Aug 2021 23:05:19 -0400
Message-Id: <20210820030520.46887-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SJ0PR03CA0026.namprd03.prod.outlook.com (2603:10b6:a03:33a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 03:59:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcb0b376-87cc-4fae-eb71-08d9638edc0c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2512:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2512E5002BA1179E51AD8BF981C19@SN6PR10MB2512.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AKLK/hgIXbSG0+iMM7KY/4ktd0YHrDNsoBJyaqoSEZHc1VHSDeh2JO5c+mv1rXMbcbyLzsqWV9LOAoOJayYGKvvc9Cq6WGYyER497XzEXDMOEnIJAY0tEbwHFDy6PLU/oZHS1pmJgQkWNlcu//lpYXXzn6xReaPLoUEKBgtMql1LyTVm2AuKEsKdFw6xw8EdOsVbCNfyjwQ5gj7F2cmc8dyfT5RrItaz0X5yUjWAUaIiQ6z8cRHNrkbWCORbw1yCQvSlBX+sr1JjmeyCAfuzQizra9R/44ez+/3sBMwvmmXETbV+NaWXu9B9Kljy7VZWbUzzzrE4xPst92MU6cC8GgjgRQ1gMEtXqehijCdHuCMhhV0IiLMan7JfVX3MQu7aOf8eUblFb57yKFJpJ4s/ymZ/Tl1O+5iBlViGSeJtcU04o6/lnx8dtwKadIRTZnFQcauLYFm/cCun0OwggXk7fkx50CMFjPgPuPeJCLn7GNAzy0RA8HWGKPsI1hGPA/mhzfNTK2tbpoyozRaXbsBa0nq4oTZxS1qSRpmV1Orur56x/tqwCEI3DXSZIpaiVTFJrX391IT7DestjhAScoNLZUAmC/kyqdcWqBWmP180/eWKpnfukflrY87Fi5+yO0HRk0IGNFmgf/jJt2D4nUWbvv8c51PEMiz5r/l35lmHvODhuoyaK2F/rnuMdaIsHfTYWDN4tYI9h7C99k62SCc7jA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(2616005)(478600001)(38100700002)(44832011)(66476007)(86362001)(956004)(4326008)(2906002)(38350700002)(6486002)(83380400001)(8676002)(6666004)(66946007)(1076003)(8936002)(26005)(186003)(316002)(7696005)(52116002)(36756003)(6916009)(66556008)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d04EvjEEo2+FbkDoMnnLioVKjchi6udTsTN8UrUtMwk/dSasHEJogYQYK9Em?=
 =?us-ascii?Q?DfSA20f2b6iDf6KcxcvYx64FvO4Nqz85SkJpqL5BpzONcbntwnb8tUwXWvF2?=
 =?us-ascii?Q?Qltx7+nD3gvCBE4zVEn38MxBjvvhuSxvYiz4eVee4RxcVhCdxbo827Wt1SpA?=
 =?us-ascii?Q?MT+HxLJD+yezNk/FqLp+dg83AVd5RuCjuTcBsdLP88HncNnb8vCKs+/bjnuq?=
 =?us-ascii?Q?mxuwuM+BZC5Q+sBg6QqLSUfMNyi3FFzX4R1NxZj2fg4UE9lRFOOgmEiDpdBv?=
 =?us-ascii?Q?nv/I0h/v06XXLAln4vsA1XaQTqGGM13Gke+fCGK7h6HSila8LX9X4vkMNIho?=
 =?us-ascii?Q?NQ6YwbDBaBmRHpbqa4iAFx7r7WymB60FjXC/r1YHfDm32R8DxJS/ObUHIGLQ?=
 =?us-ascii?Q?zIefUrnp5czqpAHJX9LZnvPDjxw3omCkGnYhHGwd/4bnNF/KHuOLFq/ukxIP?=
 =?us-ascii?Q?37OFUsO0OsmMs99A8oboGIC+C2D7I57Vb0vh8pT98VNeRSBhBuBljz1tNJEW?=
 =?us-ascii?Q?WtQZUnP0bmA20vFVxUR4nmmTyh4y0jups4prS95G2CXpUJHhmUNtUjCcQDM3?=
 =?us-ascii?Q?627WpC3c3YOUspTRptK/WtjLVLV8U2YWCOOFWHgtNk+wYnCCMpfqQ3TPfEMQ?=
 =?us-ascii?Q?KeWHnEfVMv1J0DPkiVx8h62Gae+Vx1ff64GCcm99ypbQFXA2b9twgBbTGFHP?=
 =?us-ascii?Q?8t/E2m/tHRLsCKoi9ULnJMqqCKXvSZXHZq/TXxg32usJva83/YUUx/14iIdi?=
 =?us-ascii?Q?B6TcL6+uEF/Dx60iRKZFSrHjGLquGTVlbTBkCcZdpcOUqxN2SYugrtp0ZLgi?=
 =?us-ascii?Q?4b81wmE77R5KKK/uVaTcWx2vjFdvcryk33GN4A5mb9hx5GOYN7Y6TowTF78o?=
 =?us-ascii?Q?C8Tm4J5XiV4qsTtzTTep2sV5/LtUSY68PLPtLAukPEs6X4vKaIQOUek6D9o+?=
 =?us-ascii?Q?oWMHfon6SWI+k0HTyFRJu8wiwSnUFpKW8hGgxEHKjDVIQN/tmZYIvCCGDYp7?=
 =?us-ascii?Q?71vhQCjiQTrK2bXbotJx5PtHA7SIjwQ4mYMmMnClUkOIptNRbn4rAEsT97Pc?=
 =?us-ascii?Q?m0R34P5kFe0UMafWsWhTLH9s9CHRtWogIiRWL4BGXj/yCK9B0br/3rQhKJLY?=
 =?us-ascii?Q?92h6VqgcQXyj6PVpYuddKdNlRc3sKSK0dRtVfTCBM3udCGu6eK9NKf2/ZFFw?=
 =?us-ascii?Q?pOL+BbqJhdnbZKBmxKTCmlNAuCw0WGzRy3R0mM/M2c3axROi9h2EEBOLTHt3?=
 =?us-ascii?Q?N+wqA7O4kbkoyK+OQJZO+Z64dMQVPGXLWj7mrMKa/Ngfh0uhEuYwFdTCkArr?=
 =?us-ascii?Q?Zctbj2Ue61NjBhHEZEcjLx0Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb0b376-87cc-4fae-eb71-08d9638edc0c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 03:59:08.0234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YgdrvuHlPPOeQkH46SDEtb8FsKfPck8dJ0p8cg2rCC6dCMY3tNOan0+JRPnHGXR/nmWAG+yT07ZGZI4ttEIQ6y5ZwYR5iSZWRB8wb70nu98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2512
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10081 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=839 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108200019
X-Proofpoint-ORIG-GUID: 2oiTRpGdR04tgTtyAj0DE4y9u4FLkx54
X-Proofpoint-GUID: 2oiTRpGdR04tgTtyAj0DE4y9u4FLkx54
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	1. The tracepoints will print "nested" if the VCPU is running
	   a nested guest.
	2. The commit message has been modified to reflect the change.


[PATCH v2 1/1] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit}

 arch/x86/kvm/trace.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Krish Sadhukhan (1):
      KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit} tracepoints

