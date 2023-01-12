Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D94466727C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 13:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjALMpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 07:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjALMpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 07:45:45 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B3C25F;
        Thu, 12 Jan 2023 04:45:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOYLFcHowxcle05aQMdUmWU1dDIwb6v945T1uvq0ggNXCi7P5z1A9TQ3Z7QkUAcDng3Ud6PvwNetCdJRWOYdGxCU+FImy32SE+vsLguD026YD8ZaSsuqvamS+kTRSeo88opXgpct2PHQKJoo7BQ9Nct+AzsMI+fFmC9431bu/+QPLX+4yM4X6vwb79nE/8+gh4F7iM2dcwiTxGkldwE/hr6J7eq52rXTy/4MBE7u+1TQwf1jYQGV6QUzavJZJLsQD6Erb5y6XQdx3StmQTJD4rtzhPEJvE7F4bGCjTI263iQ+h7tNf1OTkRYvR6KCnboV5Vll0bRXzoTv82U+QnraA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6TpwpFPR7yvYZV+7IuCA2Kf/fjOJsrI8EwxCYjuiaA=;
 b=fPyrRle/ByyjBEwdMrtQ8o0TqC2iG2lX1l0VMXheWruZ1HvXjRUIoWIPXOrGyj2sOTaWuEbUQHj6tZt3l/Oa2ogz+5Z6isKojZ5cPiYJv2vPYfLElhp2vQtQXRLwcFZe2xIN22HyTTUnrwCn5AX19AKDXgSXWVRbAlaIZpnmr+JsPAB9OD8eLuJ6u9aAy3wSNWko4ySrgN/tOyoY3tI5J0h9GWP39VoP4ECOm4InrzSvJQkp+aR6g4/qqOihcnk5ElqzWhu0ILHCYwbm0i4Owv+cd3KFdnTRm02TVT1CJn4qNpzDiHOlLwErh96fC1QNVrqVAdnqhXeUhJ2Jr3fkIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6TpwpFPR7yvYZV+7IuCA2Kf/fjOJsrI8EwxCYjuiaA=;
 b=h1Ayt6+mJXahI5Xkv0nSIfK++5/rnCuh2viWsYn32f4l+eN2eSjGp/FS9a9AfwCktSn90zmxFz9xXPQVnhCxHw1Zb2IxERh2TmeURI0WTYDoqD4bLzG4QrSsj8/hDa3ve0fVsT3bNEGbbpewuCU2fWle+g88t6iPX0mnBRKEDh/lgQuZUiuzjcNW95bTWgn3m7GQDmMlD6J0NpKmeRXGvkg2zpKjw/vKABUzo8UUiTNachPTU7kipnLkUUjT6u+VT5193deP5krowkvVzRmIVUMiWCQt6TEC9Ovz442MDHmSTRr/3geKWr5+2p/wijaJxA+e9YKzOK/LRzXIoxDCKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7653.namprd12.prod.outlook.com (2603:10b6:8:13e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 12:45:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 12:45:39 +0000
Date:   Thu, 12 Jan 2023 08:45:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: async kvm_destroy_vm for vfio devices
Message-ID: <Y8AA8r5MzKQIF8I7@nvidia.com>
References: <20230109201037.33051-1-mjrosato@linux.ibm.com>
 <20230109201037.33051-2-mjrosato@linux.ibm.com>
 <Y78UCz5oeuntSQtK@google.com>
 <Y78Wk2/P5+gLMdpk@nvidia.com>
 <Y78hzsHiwaFpL60+@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y78hzsHiwaFpL60+@google.com>
X-ClientProxiedBy: MN2PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:208:15e::42) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7653:EE_
X-MS-Office365-Filtering-Correlation-Id: 734563cc-8897-432f-bc6d-08daf49ae8d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PghqCEpp6bB48sV/220GE7RASbiVpBMHewP9tILCxzi15/5PsNKuzs3ZcFajSf5Dn8JbPNnrSErYqKbva+fEmUIfuAzxQVOBCo9rY43LKFSuKJHOsMzlvSGeSD7yHw49VBLw6crDcmAyrijSYAljINrRTNHMThEKLvyXx7UC1Ek9RDnXuX0TPRHxdZLWVowRBAUgmAddviv6vWr8Z7RauLAViaGpuEWSQrphKLF5tTnWCS23kSEAS1xryOwkPNtfZAs3sdl42Wr3ohbybT98yqe0g2wg3UBrQpoQlY0nxEY3gvqjt//36coZM8hWt4Gy3APdJuTeNsEfON+5TKoCEWIiQ7+DVEc1HGc0+rVh6Imwr4tXMZjEObdiAU4TBe5pffJetGyN3LymjOcHI1vffC0TZqHjVpim4T4Ypa/HxfhDnDI7330LzeympTdgCWzZpAEZe9Sw4UvreRFFHEib9x0xr3i2OyTGN0/VQ+18MDU/y1L8E3MaG5lrmpKizVx2Q3Ls5PotRKu6i32HkcuMT6+TRlmE160Sp6Ak+dP3fl/uOvoQV5EUEdFJukt7DpjAUTCnlJ5HnUq3qbky2YAoBZnoANfHjRSZMXDo5pItLGmcJpUvffLhxqM+AO/4NujtpCjRQ+0XXhyZ3SxVHiu4/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199015)(86362001)(36756003)(7416002)(8936002)(6486002)(5660300002)(66946007)(4326008)(41300700001)(83380400001)(6506007)(478600001)(26005)(2616005)(6512007)(186003)(66476007)(6916009)(316002)(8676002)(66556008)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?54mWQ92qST0akzdhoVEp49BocPKUwZe/Ir7PGl5zkfdFY9oQ8rX7d7CKHl1+?=
 =?us-ascii?Q?0npjt6kRA+5enHLkCTkvNX5xYWCS2MV/S144uNEM8J4kMziAfiZ84GAcPyXK?=
 =?us-ascii?Q?IgzHvOXvIZPDU/zCvFLTfyDupaYLxafk/BwjO8zWWdohDtVnvAAQHD9pwh8i?=
 =?us-ascii?Q?AoIzZ0zzwq2ubX4kDrsAnw9w8y7XdSX0gs/QgoRJrt6FemFu1CmyCVD8LoRq?=
 =?us-ascii?Q?wzpXKfJNR8TDZYLNJhVjWBV7QKo8xjpp4BprRNooOApgk08vKP02T5LU4i1M?=
 =?us-ascii?Q?sasaYiX0ulpmV8BuVrZ/HaG62R72jYOy8X3G+v+K+bHVo1ektiznu0+x+wZw?=
 =?us-ascii?Q?4r2U09ePU82bj5KUWmJe+ZEuw1sqpXhMqrUGz2hB53nRhEkRibOW4hlxWzQn?=
 =?us-ascii?Q?INaExAwS+AG17wMIlRsGtzu+uR6AVxOpF/pEWOiLpbFRdqjbPpzrDoM/W4T5?=
 =?us-ascii?Q?b3k8/BCU7tbSvBlxnPqZHhcO/TkAtOl2sduMxDKgaN4ELnmZvBJmPaSj0BD5?=
 =?us-ascii?Q?7p6X/gTrpZNOcsvAA+84Q+wd5GYLaqf5IuWLm7wX4wN0nqYXtxv56R66539b?=
 =?us-ascii?Q?Un8ZW+oqVw6cUHtL/NqyE1fuvUrHBdtAnNTsi73sC0eFn8M/tCVFf1TZU+dp?=
 =?us-ascii?Q?i4iHkkU82LYvVynUQu8FzNyJt8Gnhvtc+aQT8fg1IDOcshmItM8T22PpdU3G?=
 =?us-ascii?Q?9fPNqRyCxZOl1bogCWsftCfj0l0KDBzoBTIqCCDLuaEe1Ecd+YlQXI6DthXM?=
 =?us-ascii?Q?JneFR2GotFWRtWeOdwYxLz7iE1UvDm7MDti7OkyTgKX9FIhs5UtjinAhSdvE?=
 =?us-ascii?Q?TkY5x+47pIkeo6ieRlkx2DyrX4U+pjlrpYZ6RH5wzL2jKYIRQFF0jrjCw4xO?=
 =?us-ascii?Q?JyYnb7LZcoqXLXjKvgWO5TtANi1vgMo6CY7zQDeMyQFdByVPW1wkXUKXm4Ii?=
 =?us-ascii?Q?4JCzcDvMDlY8RwKXwQAAjHSYkKsc2T2DsyGZt05c9rZ3tlW8G4gTBGIdM7Cd?=
 =?us-ascii?Q?sovScu27S+sE59AIhrazm+jjoV0AjVq3lEvBYHAVjUHDajtpsIJJ2UuZMyr7?=
 =?us-ascii?Q?DnwQ1aTubjWtW1vqOzvu0lHpy7V5/ODzTLAaXiNYTrMJH/nv+ZbkFHPXStfl?=
 =?us-ascii?Q?wsTsKQYYOIoYC6Pq6LNEcXpMHsDQXI/z9cLRuboaDiWak8Me+GcKl2O5/mvW?=
 =?us-ascii?Q?oQFDAZgfBCAjzQGWnXiwGVFJfpPMnVTBeFYnyACWaIuxQ+5j0dEDMIMHddvW?=
 =?us-ascii?Q?OHjq4VurA2X4J2vwi4o4jszYO/Y2AN8vxSdpprE9JdGSALAo3kqdP/vGOFOi?=
 =?us-ascii?Q?joCrjMFUZr3sIE0mk/QohVdcF2O96eunhmhWfL/qDUPnsEvqO9gadlZuOPSf?=
 =?us-ascii?Q?Es7FxHes4RSj8SX3pSrQ27almg88G7Cb2DEEuXJsbNGjuRN+ZwVwR+TnJ+4I?=
 =?us-ascii?Q?vS6tMG45a/j3c9wSJS5RPzqdqkCgZxkpHeGvk2fqDUuDiZgCbMcSIq06KfMV?=
 =?us-ascii?Q?CYyi2umuN1Kq3rzTik5WvM/Wn7cztk1blB40mpGpI6SBReZLbcf+7S1xRXac?=
 =?us-ascii?Q?XaOFypOtYUvA50RLp4tTzT6a5CGnN55V08xx729R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 734563cc-8897-432f-bc6d-08daf49ae8d7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 12:45:39.6189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kepHIonZJlzhi2KscXV5i31gjXeKRJLPgJLKW4+QrMDbazXhG0l3jc7LVOhcLhV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7653
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 11, 2023 at 08:53:34PM +0000, Sean Christopherson wrote:
> On Wed, Jan 11, 2023, Jason Gunthorpe wrote:
> > On Wed, Jan 11, 2023 at 07:54:51PM +0000, Sean Christopherson wrote:
> > 
> > > Something feels off.  If KVM's refcount is 0, then accessing device->group->kvm
> > > in vfio_device_open() can't happen unless there's a refcounting bug somewhere.
> > 
> > The problem is in close, not open.
> 
> The deadlock problem is, yes.  My point is that if group_lock needs to be taken
> when nullifying group->kvm during kvm_vfio_destroy(), then there is also a refcounting
> prolem with respect to open().  If there is no refcounting problem, then nullifying
> group->kvm during kvm_vfio_destroy() is unnecessary (but again, I doubt this is
> the case).

IIRC the drivers are supposed to use one of the refcount not zero
incrs to counteract this, but I never checked they do..

Yi is working on a patch to change things so vfio drops the kvm
pointer when the kvm file closes, not when the reference goes to 0
to avoid a refcount cycle problem which should also solve that.

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 6e8804fe0095..b3a84d65baa6 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -772,7 +772,12 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  		 * reference and release it during close_device.
>  		 */
>  		mutex_lock(&device->group->group_lock);
> -		device->kvm = device->group->kvm;
> +
> +		if (device->kvm_ops && device->group->kvm) {
> +			ret = device->kvm_ops->get_kvm(device->group->kvm);

At this point I'd rather just use the symbol get stuff like kvm does
and call the proper functions.

Jason
