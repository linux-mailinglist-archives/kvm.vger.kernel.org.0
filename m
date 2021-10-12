Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E0429D29
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 07:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhJLFgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 01:36:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24166 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229739AbhJLFgt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Oct 2021 01:36:49 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C4Q4IH030208;
        Tue, 12 Oct 2021 05:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=ltEZ62gfuxBVe04zOM1nLmNULPUCuT3ExFGnoIklAq8=;
 b=NPo4NpuwNGu/XzrKq1EFxxiIPV3ue7G7wsuFIHs/3pH0gk7WY2rrwYYzUkyQdFavuGQV
 EdI6cqjX0kFusBhfM61M1QYItq7iN/5+27ixE7ljvS61prGX049sVb9f8UOZZbzeGlj3
 5BVvw0/hrHwiA+mSmidcWB84A8OGRvQ0Z67C7i4711HdOFPMTgaUITQLkJHydTHsSEgt
 4JRrHi8ni/ooS7Rs2I2Bu2WNHhZK43T5XLr6kbP1zHu/3qmQYV7mzicA8xJBHPIh0G3V
 Gz69qN0ozvUOB2ttkMmQFB1xCuAM8+pWLpjxf2vH8h7FFo6lmfrrs2wny5HIqmHi3JUP Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmv41jj44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 05:34:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19C5V4MW152919;
        Tue, 12 Oct 2021 05:34:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3030.oracle.com with ESMTP id 3bkyv890at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 05:34:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsaj3/Yz5wdDas2pc2D5jND+x1B9FcDGFGTKBrG1q8AROTU4bXiyEqv4dXtcmqK5e6rAwHTPLgqT87Giw+dRQYkOnsisAQImewxU4LspR/L/IXeYv2RMnDm7FqE1yoVRjLwNDSF9h7LW6vZqikz59iLFrlV612WRYPUnmmouzqupLEnG891VBLchEs/Io+k7gWX3bOKkZkGTy7Rl7EKbriEzpMgcjPpReVp/D6LQKZD2IH0OWaHLlz0pSh4fImg4GDct1Ddia0FouCJaH3anWQELeaLv4se9yJNzbbGRt07Sk3HpPMIKdmVN2O/6TNbr5j0xZ/QhKJhyhBrQ1//MLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltEZ62gfuxBVe04zOM1nLmNULPUCuT3ExFGnoIklAq8=;
 b=bid0vehqr/kWKFYhZK+VGtkwDTKZzPkw2ehac1+1S/SvRl9lSaxNhWbNnczkpjQ3bVKyYZeF+nSfw5C/K8pVG1etCpQxQr6pcvLZC05/Kgb2JClIOuGurDG71igmum7vCAZ+QkdDwmiCrdFVq0VO3i5FfD8GKHPsyhvVS/JbQAhMx6gJOxxfH9gumYG3TH10sB0how2QDFZg4VVpOSGyXrghWXN4DjSYp/Op5hO1EKikBx9+WzuMVifNe1l9XbsGJmHLIMmeeeQM6XGQxXMFknSSwAdjZ+5aO+XEFegMyK2Rp4OHJb/OS7VK4BMQeI3D4YE4oG13y+g6ZykfFERVSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ltEZ62gfuxBVe04zOM1nLmNULPUCuT3ExFGnoIklAq8=;
 b=F6DTExKW/ZVEUJjJYI9XtzFr7MJom5Va/pFltFzW4gv6Gi206oa7RADkx7x0zS8QapDIc6Epb8i1E87abex4qYvttACRus/Vtu/t1c6WY9GjgHto4uDadJjRpNc++GodikuLzuvy4lXKqSK1bi/qIB8Np5he8PsAYUMgyCuSwok=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2869.namprd10.prod.outlook.com (2603:10b6:a03:85::17)
 by BYAPR10MB3509.namprd10.prod.outlook.com (2603:10b6:a03:11f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 05:34:33 +0000
Received: from BYAPR10MB2869.namprd10.prod.outlook.com
 ([fe80::4165:ccdd:8d4f:e2a8]) by BYAPR10MB2869.namprd10.prod.outlook.com
 ([fe80::4165:ccdd:8d4f:e2a8%7]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 05:34:33 +0000
Date:   Mon, 11 Oct 2021 22:34:29 -0700
From:   elena <elena.ufimtseva@oracle.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, mst@redhat.com, john.g.johnson@oracle.com,
        dinechin@redhat.com, cohuck@redhat.com, jasowang@redhat.com,
        felipe@nutanix.com, stefanha@redhat.com, jag.raman@oracle.com,
        eafanasova@gmail.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <YWUeZVnTVI7M/Psr@heatpipe>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::6) To BYAPR10MB2869.namprd10.prod.outlook.com
 (2603:10b6:a03:85::17)
MIME-Version: 1.0
Received: from heatpipe (67.180.143.163) by SJ0PR13CA0151.namprd13.prod.outlook.com (2603:10b6:a03:2c7::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Tue, 12 Oct 2021 05:34:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74c0c73c-7a01-4a3b-a2dd-08d98d41f7e7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB35093D141F8B96238A4401C58CB69@BYAPR10MB3509.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AII3NLKEM+lnRUvPcy1I9Lp9RFBduPA19BPU9kPA1iGuy1pIZk9PZvsgWZGn8Atm90RsC8+pVzVVx7a6aru0z+Bc6RKgtic7ixTd3OPeOPbq62l/QgaeFLO2mCvjjk2FeJoydYDi0aLGuEb9LDtd4GWg+xS5aH6nGGheO97orjaLlAl2t1Ts/4btMv+2BksPZwgNR4f22AZLVIeIN621yChGnKz/ATL/crRC+roj2FvwjVdoj9uvHsyHEkPjQFi0ABTGtQ7wc2CRj5yh8Wa+ROScNYWtgFoxyyKj62qi8VhwXv6Je5O/dBo37/zxY0EDPtVp/EKClkAi2DcmawsWa+mnd6UkdMGlmE8sW3AN4s3BLm8Rk/tIHgC9K/Kwu48M90CzAxyRg9BJPOTf8ufFLkzt4EGRtx8FSTsukXruvu9XXFU88hK4+KFYxdpEDHadltJGvLpnke2fleFlG9KSBoyd0a9f3uX5BXaOPt+r0a65FpVrOi7auQOWTLOiU+v1+DBe3C9ct1HtiY2YmEO20mEdmAfaU+EtmIvMpNXQ5z8lGQ2ITlLhdWVPRdorZaleFqpnfTFzp8SUWQAvRpwitfXtcuClXuB4QNcVWwMvAfpMJNIekL31d1bT6cpx2FRthISbB9DW7xE/fjDRM9dglXfucxJIi5AsjYUC9fUabGZEFMK3822zyyirS9BhaiWAlielvqGXwJamnEbLOH3z0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2869.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9576002)(2906002)(508600001)(66556008)(316002)(66476007)(6496006)(9686003)(52116002)(55016002)(6916009)(4326008)(956004)(8936002)(83380400001)(186003)(26005)(66946007)(38350700002)(33716001)(86362001)(5660300002)(38100700002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTUyd1B5OEJuMG40cmFEOEM4Tk5zNDNydFJqMkx6Y214alAxSllxM1FaSW5B?=
 =?utf-8?B?MTBKS091MmQ3QStzVERmUXFVV2RqT3FicjVFSTF1aFdFVVdpU1FLVEdCVWQ2?=
 =?utf-8?B?Um9TRzB0Z0hlZDNaTFR3aXpBM25wTlBwQkdiK1lZVnFBOEp4UEg1RGRHMXhG?=
 =?utf-8?B?UWJCV01DdE5lNXRXUWNNL1NaaEFjY1VmajZVN0pMb2ZaMy9SZHVOc2k3dDJE?=
 =?utf-8?B?bkp5dUZCOU1vY3VHQWJsT3FlRHdiSTlqSkpxcFI5TFF2WlVoWnhKbzY1TU9o?=
 =?utf-8?B?ZEdhTHFtY2I5SnI1M0NBRFpIZVFLVStTaWZSMGEzQ25YQVFsSndnWEw0eDRH?=
 =?utf-8?B?eU1ONG1SMzJBT3pDMGltam9aVmFQZ2NsLzJBMU56SlFicVJPbmhWN3JjTFFJ?=
 =?utf-8?B?NnFCUFpiV1VCN3hjTWlvU0pQNUFQRTJ4S0w1emtHcGFSQ2Mvb21qcXZmUFh5?=
 =?utf-8?B?K3lCbHhLcHNUK0JqSTgveHBMejZzQ3B1OCtaQkxQeEtob2Q0VHg5dnVsbytn?=
 =?utf-8?B?UHFqbUNiY1N3NzJBWjJVbTE2a2YrdTdRMUIvTnNHREN4bFY5blJTcjh1M2Rs?=
 =?utf-8?B?aW0vMmN6Q05HU3VtdHp3NjlWNlM0cUl4NUhhKzdDVDQ4WVRRcnlxMXE2REJN?=
 =?utf-8?B?aFY0YU5KNlF3K00zTXkwajhBMmFxVG53QUdhMHBBSTF6WjVqdGNkblovNFZN?=
 =?utf-8?B?bTYybXNMemZWNnZDMXNoVERRMUJUR3NOdzRtTnVBSWlXUkFOQk1SOGlkRUc0?=
 =?utf-8?B?L2N0YnBmUDBHZ0ZHb3U2aUF2S253YVZCMEdkMTRmWFllcTVQWEpJZUE0cW9U?=
 =?utf-8?B?MHRaZHRGMVdRU1FaT0JTdjRpSjdjbTRiMDFBNWloeHk1MTBUbE9XUDBpcmZO?=
 =?utf-8?B?ZUNkaG9VUENTdDV4VHVMUHhoalFQaEZXVGRjQW5DNno2UmcwZXM3a3diUE5D?=
 =?utf-8?B?OXlOY0E5eGF3Ym5MTGlNYnd5OE5weG5MNFYwTk1vbXdsSkFuTElwQWVWUk9y?=
 =?utf-8?B?VTBYYzU1OGk4VDBaY1BDVyt5NjRFMHJySEVXUnVsUlV2TUdKejZLc3Q2V1JY?=
 =?utf-8?B?d1pNaXVodGNtYndmK1grQ1BPc3NacGxoUjFzbzN1SDljVDl6NTRVUTIwNi95?=
 =?utf-8?B?OWJyQy90V1lqeGgvblpxdWlWUHpNQVFqMWVrMGN2NDhiaGlQTmxVQXN3blph?=
 =?utf-8?B?Nm5rMXRLUUkyVUNlRFJibFJ1N0FMdDBvUytzaDA2SEZCanJtcUV1SkVQYW1Q?=
 =?utf-8?B?dFg5T3BEQmRuZUM5dEVXNEhVTXA3NDFsK0hHb1R4NTBYM1RLQWJJMWtZeElm?=
 =?utf-8?B?Ukc3MHJhTkpZcHUyMlBlVnR6QVpyU1FESlFtQkFSNGtDUXNmeXFsQm5mbDRw?=
 =?utf-8?B?OTJuekN5d2JUck0vbC8xRnA2NkJ6ZTJuN1lWdWRUdVdtVmVUNHNlbWp5MVZS?=
 =?utf-8?B?Ukp2MTNsWXd5b2xKRFVTOU9ydUM4NGhLeWhxNWpNOGRZdXgya0tReHBQeUxN?=
 =?utf-8?B?Mld0Q0xKTHlKbkRYY3pUQjZncmg3WnFOYzlHZEhIWi9hTHo2dkcraGZSU2RI?=
 =?utf-8?B?cElUWG9CUEdXN1hGbVNEZ3NmWlJ6clhtRVFoZkQ4V0hxdHM5dVZmdW0xa2hx?=
 =?utf-8?B?ZE1PUEJrQWRRRzVSV2lNaXBaS3dFdGd5MEVPNHFHV1RWSXd5OHlIOVhZNkFR?=
 =?utf-8?B?a3lndHNsSXVXOUVIUkxjb2hYSzZ3NWtYV0U4NE5wM1ViUzhSSlM0MnZmZG5h?=
 =?utf-8?Q?6cWLSTRjWgTwn80PTWR8SKRzxkQxZC+Q5SeqTHg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c0c73c-7a01-4a3b-a2dd-08d98d41f7e7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2869.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 05:34:32.9814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCEReSyaWWThOaaX5gKtFgy5fvH56TO21i4+GbzxQDTHESZ55kztfMaJu4rqfgmi8vM6xEZZfZjcC85GqSpfaEG7lKNuJtPYz0Lixt4wLaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3509
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120029
X-Proofpoint-ORIG-GUID: kVpTmEbQ4StGvaZtDODBjhXc8JZOitJL
X-Proofpoint-GUID: kVpTmEbQ4StGvaZtDODBjhXc8JZOitJL
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 25, 2020 at 12:44:07PM -0800, Elena Afanasova wrote:
> Hello,
>

Hi

Sorry for top-posting, just wanted to provide a quik update.
We are currently working on the support for ioregionfd in Qemu and will
be posting the patches soon. Plus the KVM patches will be posted based
of the RFC v3 with some fixes if there are no objections from Elena's side
who originally posted KVM RFC patchset.


Thanks!
Elena Ufimtseva

> I'm an Outreachy intern with QEMU and I’m working on implementing the ioregionfd 
> API in KVM. So I’d like to resume the ioregionfd design discussion. The latest 
> version of the ioregionfd API document is provided below.
> 
> Overview
> --------
> ioregionfd is a KVM dispatch mechanism for handling MMIO/PIO accesses over a
> file descriptor without returning from ioctl(KVM_RUN). This allows device
> emulation to run in another task separate from the vCPU task.
> 
> This is achieved through KVM ioctls for registering MMIO/PIO regions and a wire
> protocol that KVM uses to communicate with a task handling an MMIO/PIO access.
> 
> The traditional ioctl(KVM_RUN) dispatch mechanism with device emulation in a
> separate task looks like this:
> 
>    kvm.ko  <---ioctl(KVM_RUN)---> VMM vCPU task <---messages---> device task
> 
> ioregionfd improves performance by eliminating the need for the vCPU task to
> forward MMIO/PIO exits to device emulation tasks:
> 
>    kvm.ko  <---ioctl(KVM_RUN)---> VMM vCPU task
>      ^
>      `---ioregionfd---> device task
> 
> Both multi-threaded and multi-process VMMs can take advantage of ioregionfd to
> run device emulation in dedicated threads and processes, respectively.
> 
> This mechanism is similar to ioeventfd except it supports all read and write
> accesses, whereas ioeventfd only supports posted doorbell writes.
> 
> Traditional ioctl(KVM_RUN) dispatch and ioeventfd continue to work alongside
> the new mechanism, but only one mechanism handles a MMIO/PIO access.
> 
> KVM_CREATE_IOREGIONFD
> ---------------------
> :Capability: KVM_CAP_IOREGIONFD
> :Architectures: all
> :Type: system ioctl
> :Parameters: none
> :Returns: an ioregionfd file descriptor, -1 on error
> 
> This ioctl creates a new ioregionfd and returns the file descriptor. The fd can
> be used to handle MMIO/PIO accesses instead of returning from ioctl(KVM_RUN)
> with KVM_EXIT_MMIO or KVM_EXIT_PIO. One or more MMIO or PIO regions must be
> registered with KVM_SET_IOREGION in order to receive MMIO/PIO accesses on the
> fd. An ioregionfd can be used with multiple VMs and its lifecycle is not tied
> to a specific VM.
> 
> When the last file descriptor for an ioregionfd is closed, all regions
> registered with KVM_SET_IOREGION are dropped and guest accesses to those
> regions cause ioctl(KVM_RUN) to return again.
> 
> KVM_SET_IOREGION
> ----------------
> :Capability: KVM_CAP_IOREGIONFD
> :Architectures: all
> :Type: vm ioctl
> :Parameters: struct kvm_ioregion (in)
> :Returns: 0 on success, -1 on error
> 
> This ioctl adds, modifies, or removes an ioregionfd MMIO or PIO region. Guest
> read and write accesses are dispatched through the given ioregionfd instead of
> returning from ioctl(KVM_RUN).
> 
> ::
> 
>   struct kvm_ioregion {
>       __u64 guest_paddr; /* guest physical address */
>       __u64 memory_size; /* bytes */
>       __u64 user_data;
>       __s32 fd; /* previously created with KVM_CREATE_IOREGIONFD */
>       __u32 flags;
>       __u8  pad[32];
>   };
> 
>   /* for kvm_ioregion::flags */
>   #define KVM_IOREGION_PIO           (1u << 0)
>   #define KVM_IOREGION_POSTED_WRITES (1u << 1)
> 
> If a new region would split an existing region -1 is returned and errno is
> EINVAL.
> 
> Regions can be deleted by setting fd to -1. If no existing region matches
> guest_paddr and memory_size then -1 is returned and errno is ENOENT.
> 
> Existing regions can be modified as long as guest_paddr and memory_size
> match an existing region.
> 
> MMIO is the default. The KVM_IOREGION_PIO flag selects PIO instead.
> 
> The user_data value is included in messages KVM writes to the ioregionfd upon
> guest access. KVM does not interpret user_data.
> 
> Both read and write guest accesses wait for a response before entering the
> guest again. The KVM_IOREGION_POSTED_WRITES flag does not wait for a response
> and immediately enters the guest again. This is suitable for accesses that do
> not require synchronous emulation, such as posted doorbell register writes.
> Note that guest writes may block the vCPU despite KVM_IOREGION_POSTED_WRITES if
> the device is too slow in reading from the ioregionfd.
> 
> Wire protocol
> -------------
> The protocol spoken over the file descriptor is as follows. The device reads
> commands from the file descriptor with the following layout::
> 
>   struct ioregionfd_cmd {
>       __u32 info;
>       __u32 padding;
>       __u64 user_data;
>       __u64 offset;
>       __u64 data;
>   };
> 
> The info field layout is as follows::
> 
>   bits:  | 31 ... 8 |  6   | 5 ... 4 | 3 ... 0 |
>   field: | reserved | resp |   size  |   cmd   |
> 
> The cmd field identifies the operation to perform::
> 
>   #define IOREGIONFD_CMD_READ  0
>   #define IOREGIONFD_CMD_WRITE 1
> 
> The size field indicates the size of the access::
> 
>   #define IOREGIONFD_SIZE_8BIT  0
>   #define IOREGIONFD_SIZE_16BIT 1
>   #define IOREGIONFD_SIZE_32BIT 2
>   #define IOREGIONFD_SIZE_64BIT 3
> 
> If the command is IOREGIONFD_CMD_WRITE then the resp bit indicates whether or
> not a response must be sent.
> 
> The user_data field contains the opaque value provided to KVM_SET_IOREGION.
> Applications can use this to uniquely identify the region that is being
> accessed.
> 
> The offset field contains the byte offset being accessed within a region
> that was registered with KVM_SET_IOREGION.
> 
> If the command is IOREGIONFD_CMD_WRITE then data contains the value
> being written. The data value is a 64-bit integer in host endianness,
> regardless of the access size.
> 
> The device sends responses by writing the following structure to the
> file descriptor::
> 
>   struct ioregionfd_resp {
>       __u64 data;
>       __u8 pad[24];
>   };
> 
> The data field contains the value read by an IOREGIONFD_CMD_READ
> command. This field is zero for other commands. The data value is a 64-bit
> integer in host endianness, regardless of the access size.
> 
> Ordering
> --------
> Guest accesses are delivered in order, including posted writes.
> 
> Signals
> -------
> The vCPU task can be interrupted by a signal while waiting for an ioregionfd
> response. In this case ioctl(KVM_RUN) returns with -EINTR. Guest entry is
> deferred until ioctl(KVM_RUN) is called again and the response has been written
> to the ioregionfd.
> 
> Security
> --------
> Device emulation processes may be untrusted in multi-process VMM architectures.
> Therefore the control plane and the data plane of ioregionfd are separate. A
> task that only has access to an ioregionfd is unable to add/modify/remove
> regions since that requires ioctls on a KVM vm fd. This ensures that device
> emulation processes can only service MMIO/PIO accesses for regions that the VMM
> registered on their behalf.
> 
> Multi-queue scalability
> -----------------------
> The protocol is synchronous - only one command/response cycle is in flight at a
> time - but the vCPU will be blocked until the response has been processed
> anyway. If another vCPU accesses an MMIO or PIO region belonging to the same
> ioregionfd during this time then it waits for the first access to complete.
> 
> Per-queue ioregionfds can be set up to take advantage of concurrency on
> multi-queue devices.
> 
> Polling
> -------
> Userspace can poll ioregionfd by submitting an io_uring IORING_OP_READ request
> and polling the cq ring to detect when the read has completed. Although this
> dispatch mechanism incurs more overhead than polling directly on guest RAM, it
> captures each write access and supports reads.
> 
> Does it obsolete ioeventfd?
> ---------------------------
> No, although KVM_IOREGION_POSTED_WRITES offers somewhat similar functionality
> to ioeventfd, there are differences. The datamatch functionality of ioeventfd
> is not available and would need to be implemented by the device emulation
> program. Due to the counter semantics of eventfds there is automatic coalescing
> of repeated accesses with ioeventfd. Overall ioeventfd is lighter weight but
> also more limited.
> 
