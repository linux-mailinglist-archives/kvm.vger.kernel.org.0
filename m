Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9FF1E8E0A
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 07:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgE3FwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 01:52:04 -0400
Received: from mail-dm6nam11on2046.outbound.protection.outlook.com ([40.107.223.46]:32890
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbgE3FwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 01:52:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKBwAlK+sNvl0Px81Uz/YnyOHjdNC/lmUo0qCOs9SlkmFTiG37wk0eMyOy/us9OqLtdrER/JEGfy9NTNl4QDpOw3lWj8ji3HjmnJkmWnejziwAQLFG72Tmkj8a9pQ0jfmdR324ue6ZJ927yZ9WKlLGhbF3hY3+NZMUDrk26tcos5tfWzGK78SvByW9SH0I7mFuzwGU7iJ+AVgimDeEbQGX2BzQDvGm7yCjlBgX9N0jW3SArDC8C13IOZO/YB01dIZnEdJMXzR3aNktgLQtjxuV1WvhdS/MhJK9JW9mV71mmiXtFD8nAlbgCYGeehNIeyyF8vHWge4nDDvpSd387FXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0Hhl50JQ+MBMhOY4Fj3XN1rA9h2KkkpXykRWNQkV4s=;
 b=THDd4ZBsPOiAzdFHIKLzm5Ilb4sRCN51glS3IBlwu6Fpv0UkUVt3dj6oby7f4ozw2Kqrzvcrx/kNP1/tIG9vMx6fU5LX0mq7+xhF68wh/k9kbXqiphWWbVz/7dG3vNf39LrgCLQkge5j20kDViML2Btgw7Jf7xYJnZA6uz6GYmhEuTvt+YMTSLSdYQKfkGNF2yTJGTsvS30srwJIyoHML60yWMsJzlnlmXwjKCfjXwyl390FkoAwmnkm/HUmPwgo/EdvDWbD/m4tl1TsN1dT0OuNKmMYf7W4gRXJvRCcb4theGl7j+vmmXO4VWHEFMIunJKTrkZ5Rzk93rheZ3AEHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0Hhl50JQ+MBMhOY4Fj3XN1rA9h2KkkpXykRWNQkV4s=;
 b=jL/L22hBZlj+jVUTKO0JxZ3lvfqmrI3VqY6kooV9I8UAQLbgsW/NV/WxckS1+afuvk03E6vmxv/8aBvT7o1zcqz7CSre2tHcZT3qyyiP1jdtBmTs0HWaA4dzWsSbWgUEYvRYoSCTSBlOpgF95SFWyik4MWTDLhvT9FIDAad6eHc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1275.namprd12.prod.outlook.com (2603:10b6:3:75::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.17; Sat, 30 May 2020 05:52:00 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 05:51:59 +0000
Date:   Sat, 30 May 2020 05:51:56 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v8 14/18] EFI: Introduce the new AMD Memory Encryption
 GUID.
Message-ID: <20200530055156.GB29246@ashkalra_ubuntu_server>
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <abeea5c7dc54cf86e74bc9d658cef9b25a8fac6e.1588711355.git.ashish.kalra@amd.com>
 <CABayD+eFyWG0-Pa6hX1_HLGG6oyq=cVG1skpvJomhfpBhifoHQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+eFyWG0-Pa6hX1_HLGG6oyq=cVG1skpvJomhfpBhifoHQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN2PR01CA0045.prod.exchangelabs.com (2603:10b6:800::13) To
 DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0045.prod.exchangelabs.com (2603:10b6:800::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Sat, 30 May 2020 05:51:58 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52f2bfd2-f058-48a3-9a77-08d8045d91c8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1275:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1275479AEA41BBCA7A8FEF6E8E8C0@DM5PR12MB1275.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rUq2/Z2DrIqoWW3cZGGdQFiYI4ih4B1oiGQO/mpcqi/mkaajko+FhrOwV2gq4nY6Osw7Y8tuvpCjPuKe6+hVE8BaSsHaq/ThtFhqmV0y4AEGqaS7t4QbB3BO2oTWFxhHSimdzFxufTxMhOk0UYnyAiRowiaVQvbcqw1iVKY+4HA+dEi2thyLx7zKwo058sxiiz4jKSEhoS3EyMvRmjq7VYGcSlViU/106qmPS/Hz82Ta6C2l0kXnulI/U8qb+HScGSN1xAEuBzNgLtuk7o1l46N/I8d/B96C8q+ONP1NzrHhBB1cKacAS1J1DLMQenQaStbmdvo1ZwNGL1ZK4ZauEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(55016002)(6916009)(316002)(5660300002)(52116002)(66946007)(54906003)(33716001)(16526019)(186003)(6496006)(9686003)(44832011)(26005)(86362001)(1076003)(956004)(66556008)(83380400001)(2906002)(7416002)(8676002)(478600001)(66476007)(4326008)(53546011)(8936002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1nfDe149n9a//aJXl2IzpbNS3KQ2MfDo1E6AcZ8W4XR8SXzw4DS+b/5EyZk2ED7KitO+pZQbKESqCJ1SEHX/VOB9UlsglVkLv2TVf7TQv6oTA1l/iQMrjZMRJqLLr3vHAllsCes1FKCcArTCtAfBBkFVjT5jCsPVwh7ya0gvK1ByJC3Q8VecZ3WE4/FjBbtQTkoXzk3J7W4VOSCFKMd+Bni7geTVO+TXDxRbKOVsDRoBRsnev56Uz9qhlvAzXCWDoHQ8paHOU7qn4NutRqHuvgIpqPhDP26WRAgflAQxwKYUtwdASG6BBGxrbUY6m/E/9m+KsEGBTDrTnKRDpdSI9Eo/R3yvJPfGMo/hv6+AEnSDoAQxcot9yq82YCECcOsFKax+XCyGNbEWCg45qp1uR95XNwqLz2t4LKVHvhcSIATQPWGv8q5DsfZYLhjUg15jusagDWnYweq9yP3HPV7ZGZtI1O4NMgu1r4HoHy2BUe0=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f2bfd2-f058-48a3-9a77-08d8045d91c8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 05:51:59.8917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrwy8VNiz5JWCyCemdU3zLg5jACOdZPMMYYkaAV6P78+7MyM0OwCf2xkJRAJOG0OWrf4BptQlN0/I/1+PI/GMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1275
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Fri, May 29, 2020 at 07:07:56PM -0700, Steve Rutherford wrote:
> On Tue, May 5, 2020 at 2:20 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > Introduce a new AMD Memory Encryption GUID which is currently
> > used for defining a new UEFI enviroment variable which indicates
> > UEFI/OVMF support for the SEV live migration feature. This variable
> > is setup when UEFI/OVMF detects host/hypervisor support for SEV
> > live migration and later this variable is read by the kernel using
> > EFI runtime services to verify if OVMF supports the live migration
> > feature.
> >
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  include/linux/efi.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index 251f1f783cdf..2efb42ccf3a8 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -358,6 +358,7 @@ void efi_native_runtime_setup(void);
> >
> >  /* OEM GUIDs */
> >  #define DELLEMC_EFI_RCI2_TABLE_GUID            EFI_GUID(0x2d9f28a2, 0xa886, 0x456a,  0x97, 0xa8, 0xf1, 0x1e, 0xf2, 0x4f, 0xf4, 0x55)
> > +#define MEM_ENCRYPT_GUID                       EFI_GUID(0x0cf29b71, 0x9e51, 0x433a,  0xa3, 0xb7, 0x81, 0xf3, 0xab, 0x16, 0xb8, 0x75)
> >
> >  typedef struct {
> >         efi_guid_t guid;
> > --
> > 2.17.1
> >
> Have you gotten this GUID upstreamed into edk2?
> 

Not yet.

This patch and the other OVMF patches are ready to be sent for
upstreaming, i was waiting for this kernel patch-set to be
accepted and upstreamed. 

> Reviewed-by: Steve Rutherford <srutherford@google.com>
