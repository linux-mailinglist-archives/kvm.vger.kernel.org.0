Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9C1492F00
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 21:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348319AbiARUK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 15:10:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15870 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231417AbiARUK0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 15:10:26 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IK8DwJ002865;
        Tue, 18 Jan 2022 20:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=dpQDAxW30CfR/BgzaiJBo/rOpbT3FERiUjr1xmAzM5A=;
 b=dr18XENRinWJ3f26ZlnSDLnn3jEP929B70qw23SkNjN5vn4wTEuALPU0ztyD8Xl1hyI6
 LTcFKerKzE4QaOSV891p1elPhE50ZypwtvgWu4xkEAEcUfgnLfgP23Zy5P1oASKbeMC9
 MiKwtBq8CH/hDGrahaWy/nEnXx1+dt1cebXZhcyjZgAoiuPnau4J/02aCH0g5CaQIl0j
 O1jK05De3a/ljfgbEZTpT0n8lxsEmOs3UpJhIZY7kdKsn1mDeiffjjLvb5TaRj/OoLF3
 7yb7DCl+t1chPXni+86qOdK3Bd9Ok/XZT1Ih8jNAnOQJ7+66rx/9il0Y8mzrLXrDUvi1 XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnbrnu1wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 20:10:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20IK0aw6159747;
        Tue, 18 Jan 2022 20:10:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3dkkcxw486-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 20:10:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WI4sG24NX/SFTbuaB/A7wcoxwQi9NyGBfG5KotEWLae6ZhSBTyWMAt9BwcIUnrruUXarfik/yfiHDOX8c1ixwRuiA5cYB2eV+q+XzqF4bomzYO1AoZL6hUytsNFvBejYJ4lbD68gjWHgpVZPXs7EpBx5sleelsWcbcLFdpgcb8E+aEYu4shKGnyQAoNdjCYXVwIYJoHww+g84e8Y8KZUF13mcftI29U61abjsNgjx1mOIQpKnqStLZZh5vpSk184X5rLlMO8Jz8qh2448T9BtF90OtoUpSp/9gspGeTyvQYRuOtwlpuuBbqJEEqr7+PiIyTBMFDEzjgVIY2JdwKqfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpQDAxW30CfR/BgzaiJBo/rOpbT3FERiUjr1xmAzM5A=;
 b=TA7jWOb9kvoWBLMGahxnBbGLUI0IMCE3F+3j/RLJrJVTix5iAx8Rk/TbFo5wMlZU+F6SwVJIk/a2wnXLaLk8eRzOoG8pT54as9lzs9eWvtYYE9qz5he/ynobu+TIq5rGSZIf8bJxtS9U3u1DSvy0FnquC+0a/TrudSXB+Z/Q69w3FIqfLnnZpLNO/n1gQtRGvi11gU7TyI56dFGJeCPK5LAFK2tXJRKr66lmbGg7EadFhu+Y2ruoRhEiHQ7AgBb+WICgDkH8XU647OgfswtpR2gKFE3cKMFkkU8ATDIKdN3YggnTunVgrwUFcJNXmwi6+S2dP9t1kp9pmdg/Atn6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpQDAxW30CfR/BgzaiJBo/rOpbT3FERiUjr1xmAzM5A=;
 b=cACDPq4fHD2jiD1vjInEJ+CvzQTS/FJm6h4/zBQBdYDOFjkppFshjB37XJ9IYtnmClrzgxgxVtlKZ7OGzNO9KGhshvulVIGpHfwdYZDR7canC8LqaNZ6EpOZfQxdP3Sw/Mg+GxooRk6+Iq2TbokLj+XqmE9McfGMXS4al+rGp4c=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by PH0PR10MB4565.namprd10.prod.outlook.com (2603:10b6:510:31::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 20:10:20 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c83b:812a:f9d6:b70e]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::c83b:812a:f9d6:b70e%5]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 20:10:20 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, mlevitsk@redhat.com
Subject: [PATCH KVM 0/3] nSVM: Fix PAT in VMCB02 and check PAT in VMCB12
Date:   Tue, 18 Jan 2022 14:14:46 -0500
Message-Id: <20220118191449.38852-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3badfeb6-1376-453c-2a8a-08d9dabe8d8a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4565:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB456549413EF01D5E32E1EFEC81589@PH0PR10MB4565.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PFtVW46ywlMQ2LNSo6SLEo3tkzRBMr2Y32p+41hjWFMIk5UAzZxLDQyru/nDKMwO1HthqWII4Sns5xVVTSactjOfCNKgBWDrJBi9yJ8Zg8SfzyIu6L4n2L43XNED2e4xl4Gn+vnOLVjtrLUFuLhpxgaB6pjPCYxK/pXGeSya/vgtvCElHbwHzw45u63jtn20dGftBLUaMmqk62sa7KQ18yper9ou+awZvAhFlE8e8WSiumcsf8EYbdPFLiXqwjALHHi/4IuTW3Fx+2HAY8MvR46j5FYtr64Is40D1HWsUw3FmyY+mx/qMGrIv5f0IdS5r1oYNPHrnNYI9dQBPCPCrql7f1mSsGZUmz9PCLXB261OsJke8913YTiJMW0KPEIk1/n+03F6hWhxBeENZU9PYaKnxuKS2TPwAnKvfAwAU3GmywhOkZMr0OHuBK2KdfLL3Zb4fsM9Ll0dfNyKD+Vkb+MA+DZjDeDqtujjAlsdFf4kP591yZO5dBFetdwiul5s9jdxLgpfNDLXo6DUsoY9U6kZhprIA4gW159ldxhaOjAI0c7BklWoSsqgB1gTaTgv571DQlcPoDFNXUZNekwUo/ep778Rc5YYrYt+FQf2cmxOmjg7OD949O/E2FVNXgWXOGQXoiJ9eWRK1x3hjttfmEQL1MvMSrrNu42pa93Q4qo6Kb9iQn07Y1/PEsNVtct8jdmE0SeoF6c70KRG30sWYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(316002)(6486002)(8676002)(26005)(186003)(2906002)(508600001)(6916009)(38350700002)(38100700002)(66476007)(4326008)(66556008)(6666004)(44832011)(8936002)(52116002)(83380400001)(2616005)(86362001)(36756003)(6512007)(6506007)(1076003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dE1xUEF0VHBQd2xJZGpPdEtjdUN3WndHYkZ4ZzIvb2c5dnltbTZYQjJQOVVQ?=
 =?utf-8?B?WURhWkhhODcvV3dTb0Zjb0F3Vm5mRktlVGFHb1VaNTFMRlNMbmFhTmIzekhy?=
 =?utf-8?B?dVhZTUNyT2FFaENPaTRlUFBhTFFKZStTV01QOERwSHdyUXhoUjRtTFg4c1hi?=
 =?utf-8?B?OEtFQzQ5NVdJOXEwMjRPVVJVN1gzTmRPUyt6NkdJcnQxaFpnakhVSlZXbUE0?=
 =?utf-8?B?K3pKMUlXN2ZFQlk0OUFmMmdiL2VjUC9Ka2tZYi9GYVNxNFVlVGQ1bjhOUFdu?=
 =?utf-8?B?Z1BmblNydVVUaFdDNjBzdlJEbjhKd2NXbyt6SVNxcGIyRUEvc1RhcEk1ZS9v?=
 =?utf-8?B?V01sdEFhTjF2dGtGZHRDVmd6S2JlZHlhZ1d4NEY1NXd0eHJFZ3dUZDN2VjVR?=
 =?utf-8?B?WERxNkVpME5obHB3Snk5R3M1SjE0ZDJBc1ZNdWlVQ3dvS1R5QjcycWduaEkz?=
 =?utf-8?B?cVk4bHd5d0Z6V2hWVmFScVB3Vm1CRnJSSm96N1o4V1JxRHhKZFZEUFpCU2JS?=
 =?utf-8?B?cG9pMStOc1hoSmJsWFk4ZS9tVGtnMlRqamRTeE5raEVXMS9DcEF6M1h0cVUy?=
 =?utf-8?B?MUd5dHovcUM0RkpROWsvd3NKWDlDZ09TRTRWYlhONGgxUHpQdFpYRDg2ZFFt?=
 =?utf-8?B?eXdiNUsxY0d3WnJJRmNQS3pZM3UycDdBV1Z2ZTR4SWtpM2FJRUd0WVFBNnd6?=
 =?utf-8?B?OEtqSWZmdFFtVkVkclhJMlpaOWw2OHVVa0pDWExoMEFhOUVDdnA3NkYwK21U?=
 =?utf-8?B?a2xQem5GaFlRQW44ejZBN1B3TDNXK01ZRmZXTXliWnNNRTEvSTRucmNDMFZz?=
 =?utf-8?B?dnVxNVB0MEQrTU1kR0JDS0JhM0g3SGpwRXZNb0loQWVjWTlGbmIxQnlTbmg2?=
 =?utf-8?B?MXVRbms0a0JoWUlXYmlPQy9WMTJvblNQc0txSGo5UW1VY3RJSjhqOFJ3RjJI?=
 =?utf-8?B?UGEvV2tER1RRSldnc0poQ3VDMmdvQThOcHNSanYyblV1aG96Z3FKN2dwcnhZ?=
 =?utf-8?B?YmE3Z25pQkxXclkrQVhseTJxMFNKWE81S05qcThWV09DaENIQk1aY012aXJD?=
 =?utf-8?B?emZkeGdZT1FDSXdCbmhJbEV3OXVTN1JwQm1XQW14RnpXMWhLZHJNdlFDc3RL?=
 =?utf-8?B?aFFOeHdnOGRHOWl5MlNFRUdWa05DU2dDTkVFbXN2WVlkRXFHL0FDOUREMzlx?=
 =?utf-8?B?VkNTRDM1dFdlcXYyTEpHMUhCT0R0ZWs1ZUVDem53MGxibEozOXJtemMrMmpF?=
 =?utf-8?B?RHdFNE5yVjJhSUpVa0dFb3o4WlZhVVh3MXVRTGdoZm1xYjhqMER2VmpHc1Qw?=
 =?utf-8?B?SUZ3MlVKWm9RTVRsSmlLTUlTRjhSeG1LVndic3FiTFk0YlMzMCsxa1plUlgy?=
 =?utf-8?B?VzlkWUVvdVRtN0M4RTlzNFpyVWZPOVdWV0hRTkZGaXJRVWQ5ZEtWcWNrbERR?=
 =?utf-8?B?SUdVUm5lS1Q2VjRwVUZrWUNmRGdDeUtqZ0dEWkVWMFYvNEsrd0Mvc0l0aE1o?=
 =?utf-8?B?S0llMWFQeVFGWkJCa1hRRldaQ1ZUb3cxQlhBR1RjZ0ppdGRpSTU1dkY2YlFm?=
 =?utf-8?B?TnYxMGpvb3phS2xzckRIcTRodXp0QzB6QUFuZVhzZGgwRmxOTHlVZWkrbEN4?=
 =?utf-8?B?VzhXTlpKMk56Ym10aXhta3RUWlMyMy9BMHgxMjR5alNjTVYyL2xWVDhuTkZk?=
 =?utf-8?B?eXRqcnhFWUFRVXVWdkM3MjJYSS84c3pLbjV3WFhMd2RIcG5sYTZoTlJGSlY2?=
 =?utf-8?B?dE5QU2RPbUNQb1NVd2h2QTFCOWlvNm1ud0xTZnVRWkZ1U0JOUWg4Zll1MG90?=
 =?utf-8?B?amxIZzcrZmpyalhnZWNsak5VeHJuT014ZG5KQXdncFZRenlPd2JQb3lXWWlU?=
 =?utf-8?B?SGxaemZ4R3ZPQ1hHdmFFREJHTEd4SXFaMUxjQ0lic0xvckNSMGxFWTJJdXdX?=
 =?utf-8?B?ZEdHcW5TT2kxRWNrdHBMaHE2TGdPZG1KQVhLRDNjK2pIN2JEZGcrMlAwdUwz?=
 =?utf-8?B?RGY0Rk1LYnp0NmIwVFkwejM0UkdtK1EwQ1Q4OHh3TjUrb0s1K0tKRXVKVzgw?=
 =?utf-8?B?QlFTQmRIMGNLQXV1YXkwenYvNEV4aElZaU1UYXZyRndTODBDMWRFdXAvSlV3?=
 =?utf-8?B?MGtYQ0ViOGhpbUFVMllxZWJ5L3pvOUNUblRtZ2lNS2Z4Sm12VDBKZ09XNkZn?=
 =?utf-8?B?aldFQ2lMZUQ2TUFvVkpyOTNFdER0Skk3ZVdzMUkyWm1LTCtUU0FjZjVPMGtk?=
 =?utf-8?B?SHQ0QW1mWnJzV1IzQ1VveXZHSy9nPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3badfeb6-1376-453c-2a8a-08d9dabe8d8a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 20:10:20.5419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJqNwahANvpYoSFAvl+gQkRDF1DHkY1RQV0s8MLcLcC2Yy2zAqMplXFG8i4I05dRGhuai6DsD3BapP1tCKMz4epMwHBGpiSJbZEC3ZlAjng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4565
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=600 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180119
X-Proofpoint-GUID: 3T7VNALPawwqyonWGz7uQTL1SkWi1Bnh
X-Proofpoint-ORIG-GUID: 3T7VNALPawwqyonWGz7uQTL1SkWi1Bnh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2:

    "When VMRUN is executed with nested paging enabled (NP_ENABLE = 1),
     the paging registers are affected as follows:

        • VMRUN loads the guest paging state from the guest VMCB into the
          guest registers (i.e., VMRUN loads CR3 with the VMCB CR3 field,
          etc.). The guest PAT register is loaded from G_PAT field in the
          VMCB.

    The following guest state is illegal:

	• Any G_PAT.PA field has an unsupported type encoding or any
	  reserved field in G_PAT has a nonzero value."


Patch# 1 does the following:
	i) Fixes the PAT value in VMCB02 before launching nested guests as
	   follows:

		If nested paging is enabled in VMCB12, use PAT from VMCB12.
		Otherwise, use PAT from VMCB01.

	ii) When nested guests attempt to write MSR_IA32_CR_PAT, the register
	    is updated only when nested paging is disabled and PAT from VMCB12
	    is used to update it.

	iii) Adds checks for the PAT fields in VMCB12.

Patch# 2 adds a helper to check if PAT is supported by the VCPU.
Patch# 3 adds tests for all the PAT fields.


[PATCH KVM 1/3] nSVM: Fix PAT value in VMCB02
[PATCH kvm-unit-tests 2/3] SVM: Add a helpter function for checking if PAT is
[PATCH kvm-unit-tests 3/3] nSVM: Test G_PAT fields

 arch/x86/kvm/svm/nested.c | 34 +++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.c    |  3 ++-
 arch/x86/kvm/svm/svm.h    |  3 ++-
 3 files changed, 31 insertions(+), 9 deletions(-)

Krish Sadhukhan (1):
      nSVM: Fix PAT value in VMCB02

 lib/x86/asm/page.h  | 11 +++++++++
 lib/x86/processor.h |  1 +
 x86/svm.c           | 13 +++++++++++
 x86/svm.h           |  2 ++
 x86/svm_tests.c     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 93 insertions(+)

Krish Sadhukhan (2):
      SVM: Add a helpter function for checking if PAT is supported by the VCPU
      nSVM: Test G_PAT fields

