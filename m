Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87E82C7880
	for <lists+kvm@lfdr.de>; Sun, 29 Nov 2020 10:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgK2JmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Nov 2020 04:42:14 -0500
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:58529
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbgK2JmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Nov 2020 04:42:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsBfmlPio0Ue0/wjxTPsTPhcyC3juwT5BWh/BpgP9pT3op+GVf3mLh+SeCFivXX7+ISh3VfV+78aU/JvA/+l7v5d16PYcf1Gr2/eZdoKKNZpcbU5TxVV2LbPT4DcpsDLYhZnYE7hCFiQKBgev8B0k41wD0fO+U7p5/gDyuZvXLVn/xwJ/xfr5qRR4hr4hX/D2bcO++7HUpqAXKMVW7vQmgauCcSHqrBx/vVLRddbD5pD4Fuze9c8OQhuIzeDqzEu7KeXACR6rH9Vl75xmg+qr/mhcAlZ7nTOk9p1vBgEd2GHDFC2WjlWxI1uBJfHyyuJiTwWRby3onZqVvQb00yc9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5S0XRocYnepAjR/HKPUrV9v0NhzfgBxxlezRszIWXE=;
 b=AApftqcf77JA9K56u8w78HSoi6JbX97EJKBZFU1UOj5T+t7z09UM/d18caqn2W6+j77Rg0jYkAealE/apmKV3h1pwLfuiZi7d6AwUvMe6DKU+NR5hio8/9TSUgR9wcjfqOv3yheSb2eP19SIRlPjJDKmH2JIN26r7kD99MPR7vOfTQLQWIo+KBCvADIUSqkOC4WeheuoGwjML2Ah9z13VjR/LH+wLnpdDZMH+HENjCAK0nD4Lw/nUVnMyxWRTJ7rEexZDGSmR+BW0eQw90l1GkjwfWyyh4XCVFGpoEQzbbE3PTGuwnvoP2/f+zKKJHQdnr0HZhucLFDBLmFhzi5I7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5S0XRocYnepAjR/HKPUrV9v0NhzfgBxxlezRszIWXE=;
 b=2oVvRN++Zi6t+Q0OBUQwVEgjkQ28SSlQ8InoIoKDoW5q98csTtCcsXENJo1Z7EoVJfP8LIz9/apnTFE+/YlAjgAXiGM4NDrh+fHEq3lF22Wpe10XxZpdAospV0hHlp/OrjQbBfluluSPRBXgcjRZJZTRL01cCppg5RRlOULRXFM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2367.namprd12.prod.outlook.com (2603:10b6:802:26::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Sun, 29 Nov
 2020 09:41:20 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Sun, 29 Nov 2020
 09:41:20 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     cavery@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mlevitsk@redhat.com,
        vkuznets@redhat.com, wei.huang2@amd.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com
Subject: Re: [PATCH v2 1/2] KVM: SVM: Move asid to vcpu_svm
Date:   Sun, 29 Nov 2020 09:41:09 +0000
Message-Id: <20201129094109.32520-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aadb4690-9b2b-4801-f2fc-783cb4ae7f60@redhat.com>
References: <aadb4690-9b2b-4801-f2fc-783cb4ae7f60@redhat.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR16CA0028.namprd16.prod.outlook.com
 (2603:10b6:4:15::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR16CA0028.namprd16.prod.outlook.com (2603:10b6:4:15::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Sun, 29 Nov 2020 09:41:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f0d06a39-88ba-4ada-1a90-08d8944aecdf
X-MS-TrafficTypeDiagnostic: SN1PR12MB2367:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23678B828A5655EF693609D28EF60@SN1PR12MB2367.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJrEFcdvWqKTBxb0ZrmY/K8XGaCL0KWopxQMTyOCujNoMF9kSWR0tkyH2vIiSLkze0qZ52ZjBLgPjTr+aGoJNanwLr++6USxoV1hfz1R8Y/agJdBZWEDWtQAjds+H5s0kxbdkeIsRsx6B7Z0JVEhklbe7nxfq+ebIH/99ye1D4Imyhq4p4Ct+airMwnBayVdeecehbLLo0X9n3esqWkF//WA9Hi1IFlqf1mSgzY6vUQzqLewnDPiiIfjSdAemU5NTA4ZSGtO44YEkA5AXXIzEzvHrMhbF/3W20PJ97irQDijfd2IA7jet4NueNbWb3+1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(376002)(396003)(346002)(6486002)(4326008)(4744005)(52116002)(2616005)(956004)(5660300002)(1076003)(478600001)(86362001)(6916009)(8676002)(26005)(66946007)(16526019)(2906002)(83380400001)(66476007)(66556008)(36756003)(6666004)(316002)(186003)(7696005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?f2LwPQfLhSsmmm6Vws5eCTxzt8DnBcE3TYO+KmBTjrZY4MhZ54oY3SoSHOry?=
 =?us-ascii?Q?3gZgBK6Cl/QbyqnYToWJa/jO/ZwB4hIO3W001UzR7aS7L05Ow8OzytlsC7LK?=
 =?us-ascii?Q?cWxOR8I6GALbzVw/9dLYYm6sj8XM6jSPvaf2ob7DJBNPjbjjLFbNrHwfW/nq?=
 =?us-ascii?Q?J6U1pNAequyKgJb0ptcFwf+SAfQ0JA4bo/vICLo7od096LOGU2nbP2zprL97?=
 =?us-ascii?Q?ld0jbKkl1OaQWBhCz2MQc8qDTenK+xw1riBIhxWBBPIu0SVHxx0prGI7b8P0?=
 =?us-ascii?Q?t/gD+xuyt6foXxco/zBIc5bfrXjciEKbTl+Ghgyrsue4uROJBLY3F2UcCOL1?=
 =?us-ascii?Q?ExOG4hZPgq/2FcshoRv5NeZtc5Y8dCV8y79493Edd+ik93ZDTy4jCsf0tp9y?=
 =?us-ascii?Q?PqyF8sG7lM/tOzPiP8lguK629vHohC0QJ9V+bDBHDn2VoAYvcjjcysYiGIzB?=
 =?us-ascii?Q?8Tzt4+vSrefg2ecDWZlHJX8Q1m2yueP11Ogy/qvDkfqsG2jld4YE2ACTREl4?=
 =?us-ascii?Q?gPe3MdZXzkpzVstMxo1eEbhjd9g/5cUSd3paXPhMhosq52alkVYhKEGWvmUX?=
 =?us-ascii?Q?vH6n/9UtlaHTTU5NkBgN6SDgIvrNnzfJGb9LZwCtI2xZSAOMN1kDxwsHXwz8?=
 =?us-ascii?Q?D9tg1lKPzTA9QqxNn8zTyYf9G4HUWv8aAq6py4vSh+nwwcsAPuY5yCD5fmJU?=
 =?us-ascii?Q?+pA1By7SBSuEmEex64PDLZzj3WfLl9P2FnuVX3uCqRg8MN87EgvdC9oJFIQZ?=
 =?us-ascii?Q?3wzvekG+3u0lq9h0p38JYAC2hN09K5/x9qKR61yoliwUxBAsCiqBbi6qgwoB?=
 =?us-ascii?Q?b291SHcyyu8T8QxW8dZhHQK51mOWlb5iiL7BE4gZPfhI9wML5MS9ONVXk1h5?=
 =?us-ascii?Q?ZC3JVDJSk0k54yBr+p0aGzftCJbv7WOMEpVe54anOfJqMiApZER90yh0tGoR?=
 =?us-ascii?Q?YBVywUrdltbTnaE00irlPW7FpeV2DFUsF4zeXWw3j7Q=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d06a39-88ba-4ada-1a90-08d8944aecdf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2020 09:41:20.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aPqeXtmlhSor5u4Rw7ve48GYx0cScaT4wOIDFFIZRaLBMsCF5WCLM8ZvuEaoYVg/CJVFeFrfdBY8OSEGzrYNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2367
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

This patch breaks SEV guests. 

The patch stores current ASID in struct vcpu_svm and only moves it to VMCB in
svm_vcpu_run(), but by doing so, the ASID allocated for SEV guests and setup 
in vmcb->control.asid by pre_sev_run() gets over-written by this ASID
stored in struct vcpu_svm and hence, VMRUN fails as SEV guest is bound/activated
on a different ASID then the one overwritten in vmcb->control.asid at VMRUN. 

For example, asid#1 was activated for SEV guest and then vmcb->control.asid is
overwritten with asid#0 (svm->asid) as part of this patch in svm_vcpu_run() and
hence VMRUN fails.
