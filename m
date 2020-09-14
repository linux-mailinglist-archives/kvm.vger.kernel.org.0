Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99AC269106
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgINQEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 12:04:47 -0400
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:36576
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbgINQEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 12:04:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDQROb6n8gCMW0a8MdcH3fILEyMCiPMev5+7VXqSJcVUlzrqV6OBqR2nuZnYs/IkOJGOR9LcmT5FJGAUCRt2Jrtqjw8+3lE5Z96YeoZyb96HoGFIst7Rilz8Druu8Ee9k2esHGKmMt/KMdXyIm2Ynkp3BQJoBkv9rRNbd7njI0U8HePom02NwFgFk1E3qcuYlhsr62aoBvoUQs8Cyt42PqlRvArmoUhxbW5Tl05aSck6qeD0Ha5ItYmxFJVRFC13YVwU3ene1+mC7OaDSK4JAGI8fEy5o8CRBJZ5nf4D3Q/T4d9hF6fanEJSI81mrXTJNriitkcesCGe59n0umtYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dZ12nKod0FtT0v12srl/GZOspRzO3i0vNGZUjhPDaQ=;
 b=iQy34DQTPu0ic6VUzKpUj0kLrT+8WhUMIjgwZzTnOiqpJV2vQ9tmiBe6WPSZjFaSJYh9BOHg3tFPm67TQzacU7LsOe17snopaW6q54T6pZHYiWgt69+ny3wNnUXHL6p9n6TjM5Cq43ADn9k3TCToBWL2nWNaoLVSgQiELvsBmN3LbZDOissDSWqDN55uB3h5Ve3h5V7PuHVVqgpp3QSOYS2QzUK0P2QpNPTEPfKFxKCI4xUh8hZcIHX1gskohk1ckceNKIijN9Kyl6TsU8eZm0+lmAXZ81UWG7rCwM0G0CRPHRofvoCz2lCzr0poewKesSQB2yvykBZStBABkVSH/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dZ12nKod0FtT0v12srl/GZOspRzO3i0vNGZUjhPDaQ=;
 b=sGpdjxv4ABVizj1lraP6HeWIc45tHCxnN8RfGRW7ObnAA6IE6+OmHoxlafCxKUIV0fxEMw4xMyzlr35MUza8wU4NH7TYPbXSPSMyvufQY0MbHi2c1YkWT8+QTWfoaI5KxIS84mzrwhhuhlIvsdSBcyX7qT2uuTrDvkPiQBmD3dE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1642.namprd12.prod.outlook.com (2603:10b6:4:7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Mon, 14 Sep 2020 16:03:30 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 16:03:30 +0000
Subject: Re: [PATCH tip] KVM: nSVM: avoid freeing uninitialized pointers in
 svm_set_nested_state()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Colin King <colin.king@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
References: <20200914133725.650221-1-vkuznets@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <2acc6da1-4160-c717-d890-b667cfd8c99f@amd.com>
Date:   Mon, 14 Sep 2020 11:03:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914133725.650221-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0801CA0012.namprd08.prod.outlook.com
 (2603:10b6:803:29::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN4PR0801CA0012.namprd08.prod.outlook.com (2603:10b6:803:29::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 16:03:29 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d8a3d8c1-d20c-4315-12b4-08d858c7b917
X-MS-TrafficTypeDiagnostic: DM5PR12MB1642:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1642770F637074502909C2BEEC230@DM5PR12MB1642.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G2ihXC1JljTazqEchaJRbm5aYxq/f7rI3u2++pSCFq+D2f7NJQvcc9QN8tDtQ8VmRnnbdd0nAvMhJD7evRO+cVV/oRr3QQB4mW+jAA72dduFTwKV8rf1Fjaw/ssHYtRGMIS0eSZpaGTBWwx9iGE/ODPKwJTr8ew35JtfDJn2rsuTrBi9cWA5zLkXSI1CaXrRhFwOKeraov6aoReWJDsoc80u1lpXiorsT56P9OhsJQU/w3gW/sVFrmg0u5B1o9OYLTIcIJiyxas5H6seCgVpt3VxcZP7nblG0NjIW7RTjX2TSsr+Ort2owqzPq7tgBuGGPPGaqyOkl0Zzi8U6KXpAG/sHWy3MGSeGs582o7/62o3weux8werJyAFBYMzFtXu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(16576012)(8936002)(36756003)(16526019)(8676002)(4326008)(66946007)(316002)(2616005)(6486002)(31696002)(956004)(26005)(31686004)(7416002)(478600001)(4744005)(54906003)(83380400001)(186003)(53546011)(86362001)(2906002)(66556008)(5660300002)(66476007)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xJIV9n0cekshPDxG0L49bhMkh9XAPvsNteSrURtxwB2/k6FstZGvOXYIf+181240XwugcKbzdXOuenT1KW2bnZzEsVJh8VRItB+HwwBaMX8eKS6gngKBgeyKliOjCWYKOaLcGJr45nih7JJn73U8NggQXEPkb+UHykjRediPx0BgGeFtZ22qdYY5Ax7zNFfM8tDbMApm587Rg8JduKxX7ZuMYjD2tsw+G/UZ/13cOZMAemMgC/FGPPx8e/IYPp46L0VNXHhu0ncOkF4/gjjOHqfUSaXKXqXXGpN5O7sBrClgxwQMJZwYUS/ff5ZXGDneA7JcGxX1neuQFLF8T4/7P/E9CmRvrf2SEpxzK8v3eeuuH45O3QXcPeV9OlZDaHuF/84K2Nel5Vm4cbPegbgfDxl3xKKLUSQf7Wc1hC4UCYiaLgqw/50tMzAjzG0Jy08i0zZwdaZc8/EGqU7DnkHoNpewKQ+1LeToN+u4UGbqaacc0nfEFUL00uz6TcsI0h58/w5PExw1NuyGL0ldPmF73c2Jk5wjXAjK+QMTbInt5pDqpIgy6tAZe0ESacUzOE6NpkmDSg1PfiSEuoicxyRkwmil4eKkl6dNZqiZ2+/xZzWlwgiaQCNmH4kzDqC0gtGtVITOtJipapIEl0Oci0oyuw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a3d8c1-d20c-4315-12b4-08d858c7b917
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 16:03:30.2997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ch8SudEfKmtJmTIMC9nhDpZvLBSY840jdHjLKtwXlVmSxkfTuymjETm7iKIuCiMiUotN4+gzCCCzkv79jeJkow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1642
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 8:37 AM, Vitaly Kuznetsov wrote:
> The save and ctl pointers are passed uninitialized to kfree() when
> svm_set_nested_state() follows the 'goto out_set_gif' path. While
> the issue could've been fixed by initializing these on-stack varialbles
> to NULL, it seems preferable to eliminate 'out_set_gif' label completely
> as it is not actually a failure path and duplicating a single svm_set_gif()
> call doesn't look too bad.
> 
> Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures on stack")
> Addresses-Coverity: ("Uninitialized pointer read")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Joerg Roedel <jroedel@suse.de>
> Reported-by: Colin King <colin.king@canonical.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
