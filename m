Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB886E0E67
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 15:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjDMNTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 09:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjDMNTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 09:19:42 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250ABAF2F;
        Thu, 13 Apr 2023 06:19:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khZvM4rmaBxbfc+gsSiaGszyt2q+2E4Dk+uUsS7VyMbhy445XyPo3LnGA8kQMwnCsRee5L5m1aapqYwC3odb39/TNE+JvUVoBQWGMyVzzY5UF4rjAQLizIegTCXnaTl6upGC18ST4mJeO8/MUpXxlA9vPIsqPmdRvGJBQhoB8bOBx6kcOKEoccd7wu5lW0y7FfCHRWCPy0wiYfVSNE0fTgVjiQGbDsmPhGRUT4d6lL+iWkoqh9Mb0kka0tvYyCTjnwr4F/L05W4sNR011KHvK/VkVe32VLW5cgiKHifaVg3Na6moqz8AWmIjNSK8G6210LB+TO0LJZJ0NGlUdepWXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTyaz9YMwA3g4Ox5JyZGmHHc9jVCFtqgbE9UPgwQWqM=;
 b=MNnpKsZhuBYj8H/71M5y1p7at+IrWwCaF5mgeqQLT1IDgCgGIu9lMjN76wvr6Ho/XKYWoOBrhK7NoETXLZxwSBhdoHLHES2U9YL3Oo2jN00c7W2cTAAybe48u7bDYTeITPzkN+UtYmMl0TexoK5ITQpj2r+zQePdgMh7R4/p13leiwfW8O6pCzHppBL9RVotjnRc3hX38iTtzXGExfvsS5RJ3cTq1iJ0DlGneqhmpb0LMnCUrFoA9/XH1zjf//H0x7saah7PNH8s4aNMY6Q11GC+v0CmZpznE7Mt98T+Uxj0P6BkmRl66EonDUBsCEHH39Ifxi/Oitzvt6hIrGS4IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTyaz9YMwA3g4Ox5JyZGmHHc9jVCFtqgbE9UPgwQWqM=;
 b=ML02G3Y/jCGhDcs7cGMMrJXwSdfH6SIKFOSqd8Vq2yG36J/jyT8r0YjntvZb9mAElG3A96uJ0qp2tzJDr8Tw0Jtfnom3YtcHLGd8Y1AFg10NjrnAhqZq8mF4YWQFuYcRKaH5X7tIy85oEPZqQf+O2kLBrcutrexq6NBcIhcIvZZDHuDOwTlN+8PuncTf/mtxvzAcvdvbpEmBqPj3684ZUDiEcC53gcZkGKvhQ9VtrwjgIbD5l3jMirQh7JVwdP3staEQ515ui+Juiy1jP3eoVxhKLT9kDxemS6aEkQqnrREuOi3RWz1/70LtKFSbypBvv1Lk2vXLqGkl1BltgsYdZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7202.namprd12.prod.outlook.com (2603:10b6:806:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 13:19:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 13:19:14 +0000
Date:   Thu, 13 Apr 2023 10:19:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     ankita@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, oliver.upton@linux.dev,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/6] Expose GPU memory as coherently CPU accessible
Message-ID: <ZDgBULRSNXgs7Bmo@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <86sfd5l1yf.wl-maz@kernel.org>
 <ZDapsz2QOdjhcBHJ@nvidia.com>
 <86ile0kt2t.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ile0kt2t.wl-maz@kernel.org>
X-ClientProxiedBy: YT3PR01CA0119.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7202:EE_
X-MS-Office365-Filtering-Correlation-Id: 28f9feca-2ff9-4416-b5c7-08db3c21ad11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XC8Y0UYaLwK6Vz776w4LW6tJpcDsK872jmXXzMEYRt/KbDcw84MiVlfya3MkHgT3pes66qhP6acgrascTkUMQ8+na3D4FOFicIA9t3LdrPRWtfzNw1KTGXybbZlexgC/CWrriMpCY1Ner1g9MstHsKp3ceQVSuH0/OPpyjcctY2gV1ZmMIQEcluijfTH2wvhibUE3S+JTGzfo/n7EVS5RS2HR2jI697s2j4lHcd7h7BDbR68K/iuSk1IBeIkxWUQqOV4caZlVciY+5uUHouWLsTSghXbARnm3Uztd/+FWHn0g6xD/mkQ5RSjQGUaLVwZ82JJ4PTTYq6iP47myykaSRK6aAxEsWyxseKe1LR5TtxCvbfO8CwEwz89ZrInnB672ieeyRi4YZ9dA/ngCW+Ge/PjAvPJdFjm6W/ZDz8wQSQiJn/gDd4yeGeJzAQPMwWIPG6I3s+9To80oJSkUTWXG4qQlvYDEETxdE0dTsYr8zVYNl4jNWfes8q95PPXKC62Hdh3hDy5UVTrwvqIX2MXRhNAW4E3inZtHMtO10XdOUShbb6jtdnt0Mw0TuLXGg9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(6486002)(6916009)(66476007)(66556008)(66946007)(4326008)(36756003)(2906002)(86362001)(41300700001)(5660300002)(8676002)(8936002)(316002)(38100700002)(478600001)(6512007)(6506007)(26005)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eNYiIi0dbCrK1dCnCVtkuQIZAeq2kWpXSoq4fmfNEoada5Lg7HCF3FKq7I6K?=
 =?us-ascii?Q?TNsWYng/4qCML0In9HWfVe1GcRGIsavPlhZ76sJcbTAsGX8Ln9GUnhevRQRk?=
 =?us-ascii?Q?oX0Z/QS7+9K77gVboAp/NGYfxuUJ65tTOijkNW60uHuhZK6Y+iFJznSONDz/?=
 =?us-ascii?Q?pqzcJAM8NqPiNyE786Bb18JNjkZ9QHAuesT58h1NgIgkRlmzauBX3NHr93Ut?=
 =?us-ascii?Q?DwUBgwXawMqdO/4k1I3niVMxQ+A/mXfWMpdivIQLkLNi0sBXwzI4qRXpdsi7?=
 =?us-ascii?Q?CF2rWD/hbGDWOZQdPFOMJDIionaNb/8gh73HynCNTv1Gn0sgzdpxMYlwlYq3?=
 =?us-ascii?Q?qX2xVUWVRkTHI2uCGU662uDVYbrJEezmz/h7jSeVZY04IzikcKly63GxA39n?=
 =?us-ascii?Q?i3CkgnbSOYVbrH4AJBCy/dp4g0NKGPpgnCpISoBZBnDqaPMAcD4UgUaQvvTe?=
 =?us-ascii?Q?Fo++TlqnDrsEtPTWSBBtUBnlu8DaxKrz6TiA5X1Ft0uomRelB1UQI0sxid+T?=
 =?us-ascii?Q?ie9/S4antxkfnN3eiyi1ghWLJFfg86ZPSqooG1rwtaoHldF7a1a0YtyLJ57w?=
 =?us-ascii?Q?22kWE0mzw1AOzZRMz7nMNxc97cj65wcFfmbTW2UcaUhWLMnWBi7lYtgktg04?=
 =?us-ascii?Q?AXRHdADL6NekE9gASUFbLcMXmDQhkOQtZYo2lQTs/xZUC4ftseUSsfnqSwjI?=
 =?us-ascii?Q?scE0SVPtHIGWlM/Vqmo7adHQeDZ3YLCpMtRcK9ZSa1ZGPPQ1Fr3QRQtrwbm8?=
 =?us-ascii?Q?GVhKeyrLJfHc/4HYqLIQryRCEYZ8Vx5OA/FgJBP2qCluJm7XiBP0sSWQTEEB?=
 =?us-ascii?Q?AQoj94kTBHEpQ9RaZ9nYZxSU2TWY3zK2azCYuSItdDWEXz3px3k07pUevmkt?=
 =?us-ascii?Q?o8F1mRQAcXmbNZjt/QIxIiXa7iD97mF8o7VGUQA7q3m/wSwiMAUQfXegT1R4?=
 =?us-ascii?Q?SJBQdUPg+k4cceXvhYS7nkO59qQq5hjFlY23A7YcP7Le1y9PMNuzjRaCA7Ut?=
 =?us-ascii?Q?vOVrRRphie2wZ+4IaGDT1BmgokqVASHXMJCtmOaX4RGlo0sYYyJPFZQQXAfE?=
 =?us-ascii?Q?/lufF5Wtw2JGa880aPqN50n+3H5Rwkp1e2yBGGux5xvU9JfWG6vJP9PYrLov?=
 =?us-ascii?Q?WiHkdjmfExJovocTKsegogEo+nhfQYVrA5i7q/a6rHC+IBEbkDi/lpbZtqxq?=
 =?us-ascii?Q?+v0IlQ6vufTu/aIJPkyz0Z2h6G9raIQ/c2p1KQtZ94wx61cPrh4+dIRLYffX?=
 =?us-ascii?Q?2w/HH40Spd4mmInDnt7T4MFaxiJJEXWkt+T01RZLCY5rz9ggzButKAWT/cHN?=
 =?us-ascii?Q?Fq1kV2rn7MKp2jv6XYRWBZAFNQKvD+sgW/nzKst4aeN0QVr12kUDHhIYfmlb?=
 =?us-ascii?Q?IF5LEBF35KKdx9Nvth6VvSUoNMUT8Ukxk6afdaxpurU6jB1UMmPJq8y0rQik?=
 =?us-ascii?Q?KXo0M+2KlKHO37V7fVxbtLeBcQjcg1Cz9LKLw5EYi1L3VBKWeIG86B922/hK?=
 =?us-ascii?Q?NWUnyJS47LZoTlMkVxayfVyJM7BcGFDlhkNsUXo2CZ0BiHovgXknD8j6CQZO?=
 =?us-ascii?Q?mX9F4B9j4isE6dq4SHQtoh9D5mycQA3SuSoCpNzv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f9feca-2ff9-4416-b5c7-08db3c21ad11
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 13:19:14.0055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPgn3ZatKY27qKP9Ka7vav2sBq+OAKcfqsiegmhtqppM4NsIDcPiRzXtWDpdEDAX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7202
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 10:52:10AM +0100, Marc Zyngier wrote:

> > IMHO, from the mm perspective, the bug is using pfn_is_map_memory() to
> > determine the cachability or device memory status of a PFN in a
> > VMA. That is not what that API is for.
> 
> It is the right API for what KVM/arm64 has been designed for. RAM gets
> a normal memory mapping, and everything else gets device. 

The MM has a pretty flexible definition of "RAM" these days. For
instance, I don't think pfn_is_map_memory() works correctly for all
the cases we can do now with devm_memremap_pages().

> That may not suit your *new* use case, but that doesn't make it
> broken.

I've now spent alot of time working on improving VFIO and the related
ecosystem. I would to get to a point where we have a consistent VFIO
experience on all the platforms.

Currently, real NIC and GPU HW with wide VFIO deployments on x86 do
not work fully correctly on KVM/arm64. write-combining in the VM is
the big problem for existing HW, and this new CXL-like stuff has
problems with cachability.

I don't really care what we call it, as long as we can agree that VFIO
devices not working fully in VMs is a problem that should be fixed.

> Only if you insist on not losing coherency between the two aliases
> used at the same time (something that would seem pretty improbable).

This is VFIO so there is DMA involved. My understanding has been that
the SMMU is allowed to pull data out of the cache. So if the
hypervisor cachable side has pulled a line into cache and the VM
uncached side dirtied the physical memory, it is allowed that SMMU
will read stale cache data? Thus the VM will experience data
corruption on its DMAs.

With VFIO live migration I expect the hypervisor qemu side to be
actively reading from the cachable memory while the VM is running to
migrate it, so it does not seem improbable.

Jason
