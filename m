Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B619A46F826
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 01:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbhLJAwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 19:52:20 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64502 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230210AbhLJAwR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 19:52:17 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0dVnt023711;
        Fri, 10 Dec 2021 00:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=y9hbpxj3Sj6d/bMu8d5oWOpAb1VnqF10rzfVL7ZLS5A=;
 b=umHxx///DNNrvYcW13qMAdUhd1XwAZ1eg2rwYIWKdSwzvMAQXDmAQAQ+qMytxYWKpWqw
 viIRhqxRlxBtBt4BxAjRrvCep4vnAVMcMthp+02RUjLyRswn79mHTYYJO76DE5260Mbz
 4TtoYEttRnNWUI4h9VpRzJYemS0yPm3qE5Kxgeq9ijGnpiZqgk3C1D/+ZlgXepw5nk17
 X6G0p4EyMR/6mPFKKzE8xrqOUCWhAwqAzA4UvaGvAM5nSRdfj1rFoqbZcBxNLHAKSsXZ
 EZKNyhmoLlg1a111K7Dgmv59c6UizeNy7R9v6aROVnwHs4nnMqHj1QOOireyzwqmxoSb ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctup54mjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 00:48:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0jI5X133642;
        Fri, 10 Dec 2021 00:48:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3030.oracle.com with ESMTP id 3cqwf34j01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 00:48:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9x/eQFTFCXfK8NRZhxQHwSxADLHkeu0acb8QZJ4WetvG+Ko1J0YBfbfEuDRVcVMccPN7JB1oznapsVJZXqNE7P9nsaXZcWQ9drkhvHF520UUSJ/myIp/P90yjdZcfgWoHMDT6hadXHeVZ+yMioLG+nImKFA/g03auCVMhVd4zzfNXu/+XTARR78PWhHfIpNhKPsxdYkFghqQCaTU5XkKru1tGirAq5fSgGV0vj4KW8FlDOl/mDsybGPwgx+8Jx8NJapfvuARgmCCTQvmhHH+jVdMB/bU9aRpkszsEIBeVAYA58LMsm3Q59b7p+IKYmcYEs7F11MNmLeEcsOGuu6fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9hbpxj3Sj6d/bMu8d5oWOpAb1VnqF10rzfVL7ZLS5A=;
 b=k02ft2wJOJFskhvGi4h6iu/yZPRongqT/2xHWpEqF3Wh8lLdtT/QNljiyel4N8AiTanO46S6F9DWsIrPQwS3tBGXZJEmQpMT5DXBT8lEcrr8Hue4V825blGGkzY8o69qr0zsZXOaUckFpkxp9PhvLfGKnHJFCClLOgFexKZSoG15t8W5gMobOzRcKQEV5XN1KlJHkvEjmplWhncdL/F1axQPU+loQVSchrDILuTLxphLRaCFJJsyp+laU2IrBGKs8d2b5IDb1txElEr+PMMazpghAUsfxxp67vBO/lx5ZYhhrkkG4XwGItIGeZq4P5IhD3K1CLRlAPo9opIfgWiq9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9hbpxj3Sj6d/bMu8d5oWOpAb1VnqF10rzfVL7ZLS5A=;
 b=iiVuiEjEEzjC9c70KydWluET38e/y6nZ/HoPnVL5LTmyOP+L+h2MGBTw6gguhnEWD63yDQFhi0nVaZXauoaTKCCxBkbg/KVOHEzNM2LNnc/prSyaN6S/4ae90C4PbE2Py5Ns+pzTrbxadH6n8ZYVrIRuF2q/4PusBZwiXszMJoM=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 00:48:35 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::b94c:321d:7ba9:7909]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::b94c:321d:7ba9:7909%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 00:48:35 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/3 v2] KVM: nSVM: Test MBZ bits in nested CR3 (nCR3)
Date:   Thu,  9 Dec 2021 18:53:31 -0500
Message-Id: <20211209235334.85166-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0801CA0010.namprd08.prod.outlook.com
 (2603:10b6:803:29::20) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN4PR0801CA0010.namprd08.prod.outlook.com (2603:10b6:803:29::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 10 Dec 2021 00:48:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fa1009e-32e6-4588-affa-08d9bb76cc28
X-MS-TrafficTypeDiagnostic: SA2PR10MB4459:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB4459567E4A8A8044B0E2712481719@SA2PR10MB4459.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vA8fQr0tGxUyya1SaXLeKV7O+Tq3iZLlAIgXv52STfMv7X9fWGHhfLo4ypTrjdDJJnHOmfB4gjdiFjzfqYaoWJqxJSzW12KCz5gKADW+qvjoA3N+2cKdXzs744IxAndHeEWgeVdn4HglRX/1ulZZ8BwqCyrxmM6MegX+rGFUkgJ6oPSQGILrtPB0D/BKiVnv7F5IXiOiHcswwHrG0D7kn1gPdJYffjdmR5u9VLM1+JKkPKQhAxpU7U9albU/lptXRsEbKy2c8A9RByU48Iou+vanqYU0cZRI2e+tvlA+qcJhxIfiMHmZz5AsiDMjDqGtjr/zPqpLVa38mrnYmNrSB6jaJy3iT0xgYmPQgRwEFWDBfitWKfhmmQ+ZEkUf5CjIOAOdCAzncY3KHl5i/3S4uC9C4cES69ZQ2Wlz7L5fbkQrvbVBY2GOS8tjAGIb0F+vLlEtBIe637C6bJWWtfbYzziOU4ZL+pEiee2myxH5JzwhrUbQinEgDwC+XJuSDThX11VHvp7ynjATl4ge45ToPQe26l2Hn/1KXnLrZxizviKPuBXOpX88XP9OBvUfgzSRIEnpLU3dSQ2RHYyChY5L0RTqaam/w2rokpkg9Fl4NxqD9UmPLsK3+skhXRXBU+tS+XJUHCmfy8zr1t39Y0uFZZe8HEeas3XzpXYf+krcPvbdg3OtvH8p3i1aIKMsdF/mlUt5oIeRgwGg8wCoWrDubA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(8936002)(7696005)(66556008)(52116002)(86362001)(38100700002)(66946007)(6666004)(38350700002)(8676002)(316002)(186003)(2906002)(4326008)(1076003)(66476007)(508600001)(6916009)(956004)(36756003)(26005)(5660300002)(44832011)(4744005)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8m6ESk0DOD9lPGDtrRweyhxYZqYL69eZeSnPYLZI8wGG8ELOXZGHe4kEVg+m?=
 =?us-ascii?Q?DOeFX75ds8RaXIL25HnMi/ZcEbkDP3d88L+hF/AIlIW3m2Umcu3sJDTow/5+?=
 =?us-ascii?Q?Z1FxQkVVoCpGLqFrRxhIlTyGq9GV9xGQRaR4Y6INkv240XQ3pAd70x3V3c35?=
 =?us-ascii?Q?vqVkUfjdF8wVKDlfxvWSkkNKR9CzLwlBm96EX7YaBG7aYto5V0IGeUqp9xEz?=
 =?us-ascii?Q?xXr0Gcyla+xsMknjNmaaUlLv1rb2PkMix8lZlUPOTD6eAunZfSn5zcwn5Wz3?=
 =?us-ascii?Q?I2nz9qz7lBpNJgYIvustwVs5IzCYf59IIW7v4lG9uSU+lZNIMDa5YGbVX1/U?=
 =?us-ascii?Q?YGvucuo8WyKrYUBap2lnUWeYGW3kH3o9W3HbZWex2jv9S04xTReL0u55Kqxk?=
 =?us-ascii?Q?rccb6sslxXZ+pIH4VHVMAlovHdvIYjdGzzj/k4Go1SUc7weIc5HuVPq0uxkn?=
 =?us-ascii?Q?fFMVW9PnPQIl0e7SxLAy9vwBVuD9M+JEwFwb1HobkoPhsR4GC43FlYgCxZIl?=
 =?us-ascii?Q?GaCJanaOD5st7wCH0fuQdli1OHn9a1QNdaZ+vsCsa4Zc15BvYFlAOXhjEdfz?=
 =?us-ascii?Q?Kr9+PqTifyCqSqxLtJ1Nu3HUemmzg4mPBbFPxvGSmsK+DmV3u+tT9A3+WTJ3?=
 =?us-ascii?Q?H5q2PyKWZiqttP7ff6xWJVY7Y0LNL5kKGTGZoJcAo4L+UzwXeRCATBAwsS4H?=
 =?us-ascii?Q?lt/f+HB0fxgLivYNLkPPh9bf4LE0LQsr69Wd/EfMj0jz2+1hmAo0zy/O58W2?=
 =?us-ascii?Q?LUv/CMJMZvL68Q5s+9zSx2IW4hnHTuAt3Pf35YA/SZXoyFXppnkWUsZQfIXO?=
 =?us-ascii?Q?FiAAM5dyWJKOVxUig79TwiWr8echD4XPKDkxyuB+01IUiV2Bst0Fk8N7j8/9?=
 =?us-ascii?Q?si1COj4No0XBCZhkx3fawHR/mzvmQCepm39ZfolNaVvu028OoaYiTNgX0UN9?=
 =?us-ascii?Q?NYpn6L4PBTsybFNzphhma6GNtUnneoINBlu5HT/C+YqJqlI/6kA3y2eu8kwm?=
 =?us-ascii?Q?YnC8kMxaznlZRY2qZUFx6yd507toN5EtleHZ+TGD3BMoRkzybKArTSrfDJoQ?=
 =?us-ascii?Q?zRyVrFoXHlWXBwlV9Y81CYJrJCCFvuKeCOLl20KyMlcIoh1p6sw7rlItIcND?=
 =?us-ascii?Q?5NLVIjVKxenfEuLmDAisThnVv2NOk7X9dDiHz/wPemeDVXG/b9sWbn6sBp9E?=
 =?us-ascii?Q?7NC45fjSkVINA/p7bprYNtGd2reO+iEUpaGDSOJ1IU/SR153TeaYt+Q32Uj2?=
 =?us-ascii?Q?VNprhZxEkY2qFDPrIpOdr+/JEPZ1u2Jkmnee1UbOZKtF2CjBYhYybMHjdt2L?=
 =?us-ascii?Q?4HHEbEpsdAsMghrmzg1uGYKd7EibnpmDdp5T9/GkBCKfk4dxsFDg8y6tBsMk?=
 =?us-ascii?Q?4tpspj80xC3FTA/ZL2GeAZLPKFAbi37eprSw2suH0k/PF6J2KOekg/oRdhKI?=
 =?us-ascii?Q?zOWj7kKSj26I1hmZZLROZ1i+TvnURq49jyXvaWLiJKhgO17PvR4ismLtQGzv?=
 =?us-ascii?Q?HriaxW11m9lyGnQKEgfB1el2P944qfcZ1UGS3t8BKsE9b7aNNho9ousUYtCW?=
 =?us-ascii?Q?0iZqJBQGPm4lCO+XNFA3z7+meu0d9xTIfCfHjXl9ocnR3TYGZ3PWmKb8PRgT?=
 =?us-ascii?Q?m41kqiZynIyvOky9LEdxLmjV13MYw+OZTAQUNT9uJyt+pIXImdzub9H3FbSJ?=
 =?us-ascii?Q?jcRE+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa1009e-32e6-4588-affa-08d9bb76cc28
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 00:48:35.6951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CUokuPlEVuI/mucWsNYUG2r6SZcKYe11qSPuS2Lpv0oXiuX9gVjJl3ejEXKSEoQi+fOQo3Mk40pcReF5oXGWboPFgHvML8RskdIE/Ujfr+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=476 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100002
X-Proofpoint-GUID: 2Xohvkd5BGvjkxXlZ7EI54YSx8oi2XDx
X-Proofpoint-ORIG-GUID: 2Xohvkd5BGvjkxXlZ7EI54YSx8oi2XDx
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
        1. Instead of using a fixed MBZ mask, the mask is now generated 
           based on the VCPU's implemented physical bit width.

        2. Patch# 3 is new and it fixes the existing 'test_cr3' tests to
           use the VCPU's implemented physical bit width in generating
           the MBZ mask.

[PATCH 1/3 v2] nSVM: Check MBZ bits in nested CR3 (nCR3) on VMRUN of nested
[PATCH 2/3 v2] nSVM: Test MBZ bits in nested CR3 (nCR3)
[PATCH 3/3 v2] nSVM: Use VCPU's implemented physical bit width to

 arch/x86/kvm/svm/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nSVM: Check MBZ bits in nested CR3 (nCR3) on VMRUN of nested guests

 x86/svm.h       |  1 -
 x86/svm_tests.c | 49 +++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 5 deletions(-)

Krish Sadhukhan (2):
      nSVM: Test MBZ bits in nested CR3 (nCR3)
      nSVM: Use VCPU's implemented physical bit width to genereate MBZ mask for CR3

