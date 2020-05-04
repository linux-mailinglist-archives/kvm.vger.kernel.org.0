Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF43E1C49A4
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 00:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgEDWgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 18:36:49 -0400
Received: from mail-dm6nam10on2085.outbound.protection.outlook.com ([40.107.93.85]:26176
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726334AbgEDWgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 18:36:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnJMCZNMDD3DWmWQwmLIPNtgEJw5csRhDNfv5Taj/YPQpR2nf173E4ibj1KS6NVhfEYXUw5M6kJuDlfUj0qbXh3qiILBv03jRMwzRPNUKMc/66g7pwdi3wVWqePGqRcoGwP+9dwrJCJfU9FwVF4wQCas1gYvOedJSolJtRHBxfaWcWgiH4xSiWVzsPhGPfvrTphF1XMQSVU0siCOm1mhVUI8nxrzxdT91QWdG3ibYVi50k014RZqJmMjD3ga/AFDFF61TIW/voeaIwrq5H+u+YgsqmwzsTZ63e4C7QHvar4mofNvq2VolylSdESroaD9YuBVBiMMzyRMkeihX0nLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6HGihmv4fNZKhP6jzI4Y08HfvS5d0aEG7GRvx2aX8s=;
 b=WOvjQlX3Fd3BxeiV/KsfQdhXN6VC7amBGAkGub6qysSzAlY+erCmHzs6zc0Wyl42DaiRAJA5NxaKZpwGQFpdHZTmoEbA9l2TWv3SCz2Zm6u/gfNtwmJ4SGkMl5FnGcXBK4MJRLSyNUSxWCkC5yxNEUCE4zs0GQqSDkHk+w2cqTgJxZGCNE2NoRAHqlzCNUD+WVA71PE0pDTBp2ttMhnNxzUDMhVfi19ePHkAtk1zbjMwohVTZYc5tsQ73ZeJ6sC8rS2P5CDRhX/YHlbg4H4jkjJCFPa4N/nAa3Bfh2lP6AHvLSYG342e0BRcQMOL6TQaG80inpzhZsrtKQyjvVRSmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6HGihmv4fNZKhP6jzI4Y08HfvS5d0aEG7GRvx2aX8s=;
 b=Q9fi67EUAdrMjTl/DUqToeOKIn6xPq+0BWg8eovAdhg4YIuyOAZg5alzyJr0urlqJ2ZRQfJF3G3IXD7nMQLo/KH558j0pZxmWbcXUxkZOjA7dkOnA87hHDmebxOkHTk8wM20PPDN24bqEa7hcar3Gfn+nevkWJ8i+pAQEywqDeM=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Mon, 4 May 2020 22:36:44 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 22:36:44 +0000
Date:   Mon, 4 May 2020 22:36:37 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v7 01/18] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20200504223637.GA3615@ashkalra_ubuntu_server>
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <6473e5803d8c47d9b207810e8015c3066c39f17d.1588234824.git.ashish.kalra@amd.com>
 <20200504210717.GA1699387@vbusired-dt>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200504210717.GA1699387@vbusired-dt>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:3:d4::20) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.14 via Frontend Transport; Mon, 4 May 2020 22:36:43 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80c43054-7cbd-4649-fdde-08d7f07b9f29
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:|DM5PR12MB1803:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18034DD6A02A64DF852560AF8EA60@DM5PR12MB1803.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03932714EB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OhYIEJTFNp+3Zdr8PBT/hFlBNis7Q6rrj8ZClW6pERgEA4dNCT51XDq4IJynwptXYabDeTySRDtNLkSI7DHxzJw3JRTRlYQJhQSJoor5wefYYNRW9MsG/Up6A9hc+GramlzlIWFGRKtwCZvd3e8qbtrwCdDb43KmGJqzv++7+Dqp7zk6O3zX5yPvz4cZjwDERaKth5Hi1li+FfFUIsjgmHhM6O5ZAh0d16auXijt1AzoEUR5Zi3oTMqb65f4E6BYqn22RaNvH+UFypX0oB3S4O5yWMpgj+wDqDDUWnvdlOuRVcwW5ExJ4aCIu/uDz1wH2Hyq3mc6w4xTQsRqtd0HGy5mu4xNgkZdFtfVyFqCL1KegMfyjKHAwoymPg409bsBGaGm2V6xaj6xpCnOZ8kQRdsG4M9IC/meoOAtG6a9+aR4AX8adBg4qhtrRhUsddIDBbzmZ0cbAZeo2TIqVin611loa++quGDwj3ziXH+qAq354qxKIHsl54tv3pyGDu8uoSn9XdATfl+CE0zwbFMSA8WMxyULTOicW5Qlt10cZsHU8rZvSuT5PjcqqZjk78JCY3Ni2G7zP6q65MxjLZJDvAn8hBqbUBHLjc/jVSH19lA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(33430700001)(44832011)(2906002)(5660300002)(66574012)(4326008)(86362001)(956004)(7416002)(33716001)(6916009)(30864003)(8936002)(8676002)(26005)(186003)(16526019)(52116002)(1076003)(45080400002)(478600001)(6666004)(966005)(33656002)(66476007)(55016002)(9686003)(66946007)(6496006)(66556008)(316002)(53546011)(33440700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Q2gB6I91EmxgJJZ6rsgkl6flDfnQXo9ryS2dqv8qpW80JfFmNTX5foTuCNdL1sAxV87JmZw1kCgh/HV22KPaag6ZQ8WOi4hXtxcD+8Te1CdGAuhyS9rogyh4i+NPBDB6isG3e6J1wPOsy/5P0eiX0RrsxWEVFvJafSeBcgrzFGeagOImUhR+3W1tvhyB5gBsB3EkD0SyMW3BdTzYPVemdDrTPsgB5xHPmcYOvHzpXbAMzWEOBpooUdODFvSU+EzthDlyf1A56yf5Qy96KqURJnFMfeR8HwsLJgEQ6gMyAzY2S+3kC/Ro93Or3Z8GUkBqzEsisAzlZ2cYqBcAi7w5nJn1qjostMv080qQcoJjtIixBU/rHsJ9JOlqueV2ykPULuEAJn4l/CeLyd3eapt26ebA5wAByGEaKtkHq5oahJaV86mlq+Rgc9dVKy8qPQaN4ijOfJyz8z3l0rRtu1BYcXVutRKJB67Uw+/H2tb+A6yU9NrhTgxeHAd5seTFswZcpAZdXYTqEA73GDKn12QHFCIvB3UmT2UjdRqHqO4q2BSGYckry24zv/hnztfo1NANyyQIFoacMx6Ef/bA1x2QXvpD/fsyKbRgbJS8O5FRpuf/XVvvOZ51FrP4QV1v1wokkxL8nSHWkivIddFS3K8tebxpb7qidF9clbWY5FQsAiesOr211F0djgKV3COXpikrti664YTZV1Fgumoo478t5+vNj3cTuaLmQAJgLkz13Cpgu1OdWBJGG5k2zGFtxPHNAuA1n+6xyjwyEqtH+J4YycLfBwRFT8JokLYpqJL1z3k=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c43054-7cbd-4649-fdde-08d7f07b9f29
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2020 22:36:44.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbckAmT5JO/15AfaGbMh5a7GtcSvA2Z41TcaXmmUE+Q1qaqLo5CZKGXAAnnrjgR/fW3ONu4BFdzoCjy7mA8/5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 04:07:17PM -0500, Venu Busireddy wrote:
> On 2020-04-30 08:40:34 +0000, Ashish Kalra wrote:
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > 
> > The command is used to create an outgoing SEV guest encryption context.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Reviewed-by: Steve Rutherford <srutherford@google.com>
> > Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
> >  arch/x86/kvm/svm/sev.c                        | 125 ++++++++++++++++++
> >  include/linux/psp-sev.h                       |   8 +-
> >  include/uapi/linux/kvm.h                      |  12 ++
> >  4 files changed, 168 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> > index c3129b9ba5cb..4fd34fc5c7a7 100644
> > --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> > +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> > @@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
> >                  __u32 trans_len;
> >          };
> >  
> > +10. KVM_SEV_SEND_START
> > +----------------------
> > +
> > +The KVM_SEV_SEND_START command can be used by the hypervisor to create an
> > +outgoing guest encryption context.
> > +
> > +Parameters (in): struct kvm_sev_send_start
> > +
> > +Returns: 0 on success, -negative on error
> > +
> > +::
> > +        struct kvm_sev_send_start {
> > +                __u32 policy;                 /* guest policy */
> > +
> > +                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
> > +                __u32 pdh_cert_len;
> > +
> > +                __u64 plat_certs_uadr;        /* platform certificate chain */
> 
> Can this be changed as mentioned in the previous review
> (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20200402062726.GA647295%40vbusired-dt%2F&amp;data=02%7C01%7CAshish.Kalra%40amd.com%7C5ea8d5ae78814a01618908d7f06f7667%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242233846313842&amp;sdata=qfxRdCY3A1Tox%2FMI%2FQLmUcvIxbfL%2BwoR2fzfQa1FVkA%3D&amp;reserved=0)?
> 
> > +                __u32 plat_certs_len;
> > +
> > +                __u64 amd_certs_uaddr;        /* AMD certificate */
> > +                __u32 amd_cert_len;
> 
> Can this be changed as mentioned in the previous review
> (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20200402062726.GA647295%40vbusired-dt%2F&amp;data=02%7C01%7CAshish.Kalra%40amd.com%7C5ea8d5ae78814a01618908d7f06f7667%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242233846323835&amp;sdata=SMYG1m%2BT2KwNQ4Jed%2BJhsK6TQ7EYTKT16moEoZMTf7c%3D&amp;reserved=0)?
> 
> > +
> > +                __u64 session_uaddr;          /* Guest session information */
> > +                __u32 session_len;
> > +        };
> > +
> >  References
> >  ==========
> >  
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index cf912b4aaba8..5a15b43b4349 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -913,6 +913,128 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  	return ret;
> >  }
> >  
> > +/* Userspace wants to query session length. */
> > +static int
> > +__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
> > +				      struct kvm_sev_send_start *params)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	struct sev_data_send_start *data;
> > +	int ret;
> > +
> > +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> > +	if (data == NULL)
> > +		return -ENOMEM;
> > +
> > +	data->handle = sev->handle;
> > +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> > +
> > +	params->session_len = data->session_len;
> > +	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
> > +				sizeof(struct kvm_sev_send_start)))
> > +		ret = -EFAULT;
> > +
> > +	kfree(data);
> > +	return ret;
> > +}
> > +
> > +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	struct sev_data_send_start *data;
> > +	struct kvm_sev_send_start params;
> > +	void *amd_certs, *session_data;
> > +	void *pdh_cert, *plat_certs;
> > +	int ret;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -ENOTTY;
> > +
> > +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> > +				sizeof(struct kvm_sev_send_start)))
> > +		return -EFAULT;
> > +
> > +	/* if session_len is zero, userspace wants to query the session length */
> > +	if (!params.session_len)
> > +		return __sev_send_start_query_session_length(kvm, argp,
> > +				&params);
> > +
> > +	/* some sanity checks */
> > +	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> > +	    !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX_SIZE)
> > +		return -EINVAL;
> > +
> > +	/* allocate the memory to hold the session data blob */
> > +	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
> > +	if (!session_data)
> > +		return -ENOMEM;
> > +
> > +	/* copy the certificate blobs from userspace */
> > +	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
> > +				params.pdh_cert_len);
> > +	if (IS_ERR(pdh_cert)) {
> > +		ret = PTR_ERR(pdh_cert);
> > +		goto e_free_session;
> > +	}
> > +
> > +	plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
> > +				params.plat_certs_len);
> > +	if (IS_ERR(plat_certs)) {
> > +		ret = PTR_ERR(plat_certs);
> > +		goto e_free_pdh;
> > +	}
> > +
> > +	amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
> > +				params.amd_certs_len);
> > +	if (IS_ERR(amd_certs)) {
> > +		ret = PTR_ERR(amd_certs);
> > +		goto e_free_plat_cert;
> > +	}
> > +
> > +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> > +	if (data == NULL) {
> > +		ret = -ENOMEM;
> > +		goto e_free_amd_cert;
> > +	}
> > +
> > +	/* populate the FW SEND_START field with system physical address */
> > +	data->pdh_cert_address = __psp_pa(pdh_cert);
> > +	data->pdh_cert_len = params.pdh_cert_len;
> > +	data->plat_certs_address = __psp_pa(plat_certs);
> > +	data->plat_certs_len = params.plat_certs_len;
> > +	data->amd_certs_address = __psp_pa(amd_certs);
> > +	data->amd_certs_len = params.amd_certs_len;
> > +	data->session_address = __psp_pa(session_data);
> > +	data->session_len = params.session_len;
> > +	data->handle = sev->handle;
> > +
> 
> Can the following code be changed as acknowledged in
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2Ff715bf99-0158-4d5f-77f3-b27743db3c59%40amd.com%2F&amp;data=02%7C01%7CAshish.Kalra%40amd.com%7C5ea8d5ae78814a01618908d7f06f7667%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242233846323835&amp;sdata=5hbjsP%2Btxt2rdv2PtIc%2BV8cAwKUNsRdtiRglDupYXzs%3D&amp;reserved=0?
> 

I believe that this has been already addressed as discussed :

Ah, so the main issue is we should not be going to e_free on error. If
session_len is less than the expected len then FW will return an error.
In the case of an error we can skip copying the session_data into
userspace buffer but we still need to pass the session_len and policy
back to the userspace.

So this patch is still returning session_len and policy back to user
in case of error : ( as the code below shows )

if (!ret && copy_to_user((void
__user*)(uintptr_t)params.session_uaddr,...

Thanks,
Ashish

> > +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> > +
> > +	if (!ret && copy_to_user((void __user *)(uintptr_t)params.session_uaddr,
> > +			session_data, params.session_len)) {
> > +		ret = -EFAULT;
> > +		goto e_free;
> > +	}
> > +
> > +	params.policy = data->policy;
> > +	params.session_len = data->session_len;
> > +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> > +				sizeof(struct kvm_sev_send_start)))
> > +		ret = -EFAULT;
> > +
> > +e_free:
> > +	kfree(data);
> > +e_free_amd_cert:
> > +	kfree(amd_certs);
> > +e_free_plat_cert:
> > +	kfree(plat_certs);
> > +e_free_pdh:
> > +	kfree(pdh_cert);
> > +e_free_session:
> > +	kfree(session_data);
> > +	return ret;
> > +}
> > +
> >  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  {
> >  	struct kvm_sev_cmd sev_cmd;
> > @@ -957,6 +1079,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  	case KVM_SEV_LAUNCH_SECRET:
> >  		r = sev_launch_secret(kvm, &sev_cmd);
> >  		break;
> > +	case KVM_SEV_SEND_START:
> > +		r = sev_send_start(kvm, &sev_cmd);
> > +		break;
> >  	default:
> >  		r = -EINVAL;
> >  		goto out;
> > diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> > index 5167bf2bfc75..9f63b9d48b63 100644
> > --- a/include/linux/psp-sev.h
> > +++ b/include/linux/psp-sev.h
> > @@ -323,11 +323,11 @@ struct sev_data_send_start {
> >  	u64 pdh_cert_address;			/* In */
> >  	u32 pdh_cert_len;			/* In */
> >  	u32 reserved1;
> > -	u64 plat_cert_address;			/* In */
> > -	u32 plat_cert_len;			/* In */
> > +	u64 plat_certs_address;			/* In */
> > +	u32 plat_certs_len;			/* In */
> >  	u32 reserved2;
> > -	u64 amd_cert_address;			/* In */
> > -	u32 amd_cert_len;			/* In */
> > +	u64 amd_certs_address;			/* In */
> > +	u32 amd_certs_len;			/* In */
> >  	u32 reserved3;
> >  	u64 session_address;			/* In */
> >  	u32 session_len;			/* In/Out */
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 428c7dde6b4b..8827d43e2684 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1598,6 +1598,18 @@ struct kvm_sev_dbg {
> >  	__u32 len;
> >  };
> >  
> > +struct kvm_sev_send_start {
> > +	__u32 policy;
> > +	__u64 pdh_cert_uaddr;
> > +	__u32 pdh_cert_len;
> > +	__u64 plat_certs_uaddr;
> > +	__u32 plat_certs_len;
> > +	__u64 amd_certs_uaddr;
> > +	__u32 amd_certs_len;
> > +	__u64 session_uaddr;
> > +	__u32 session_len;
> > +};
> > +
> >  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
> >  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
> >  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> > -- 
> > 2.17.1
> > 
