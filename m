Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB0502D16
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350982AbiDOPg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355591AbiDOPgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:36:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9E7E41EB
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 08:32:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yg5mkCfLoa6H0NeNcmtKGihDy9flEr7GKw+CDmbyeohfr6v4Nl/oNxr5KsjPuMiIRxPGDWAS2AupGpWh1vu3OryJzURW1996ABJ4+ZQP6bBiOg0T9KoFrDtz8FOh0EVfrE9JUWP7NaCduD32JF9Pad+NLenUmFyV2oRON404B80hcAtz9ZWbZhwPXOWTxERGHnEc0N5k4p9fiun98jB1c2eRf/YbAnGT/ec6yk3p4KCzz2F/E1WwlG43MoVY8j0KQ8hkFmscmPMHPa5xJ0hPdEqHEYEOszoOX2t4DpJtkaxXApTFPN0o5/1bnTq3hdGtE43Q2PhogQIZyJe52L0QxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkfdCKJi40LlZ6X05u7EFLyrW+yqsZ+zFoIqkpQK5f8=;
 b=U0PZCSNNLmwVs7Pt5YQpBC5pYTHDDddfSLu7UjvMSItxq4JVJQbzP2Z9rY6/9ISUk+gEOo4o8t2dCGcfhp/7BDllRa2pTM/mXTxfNdGykgsSlLe5WoE9Dbt4PLGMEX4BJtfYR29DFDPObi4GBGgpgi3Zd6z5YX5VvN+ITEMdnjNjS4+M4ykt5/XA0UUCnIYOvpg36GKZoMPp8M1vzbwtFGo8ra7ej9+93Vy8NkUakFLYmPAgqB2Kf5tCfAmDEVP65oShBOBwiNTETLjuPey+N0VB0e0guewb2bMICYhnxZjYEDzVUt4LW313Nheb6Bwf27A2I3na81R3OPMN9Hn2vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkfdCKJi40LlZ6X05u7EFLyrW+yqsZ+zFoIqkpQK5f8=;
 b=arUbuvVZ2hW1ZSEQ5zG6TVLIp9A1/DtnGJW/B2IvoTXvn1zOzuN+274Fc+6iD3DJY8RX7oJ/eeXKCfzghz5vw3u5XJOu8loyw9LgCiR58Y3SyGtardzvbDQMewylRXiOdnXdVybECrz4KvqQqUYbS9MMt0G/if9f9sH5zPd/T8StRl+mnItEfaMzwbh6ytyTnRUJw2yKgBUn/zKiixY2qTc/DL9Imo1RvAsq8Bg7m093hzc1OtWhG91T4rZk/kTGq4voNdYCS5lFHOcRtAGCCsWW4/F6c3HtvNgkxfSr5h6cmXGsCRpZ6QNJ9hsLjY6VIH/HLFUSBcg+1sdP1a3HTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB5931.namprd12.prod.outlook.com (2603:10b6:208:37e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:31:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 15:31:43 +0000
Date:   Fri, 15 Apr 2022 12:31:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Message-ID: <20220415153142.GL2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <20220415044533.GA22209@lst.de>
 <20220415121301.GH2120790@nvidia.com>
 <20220415143621.GA1958@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415143621.GA1958@lst.de>
X-ClientProxiedBy: BL1PR13CA0360.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a6da303-4176-49c8-1d46-08da1ef50b92
X-MS-TrafficTypeDiagnostic: MN0PR12MB5931:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB59319CDDF747E591651B30DBC2EE9@MN0PR12MB5931.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4hDxLFUtTBbMJiPXZZJSLfADfIWT9WxpLd8upceQ37cSbGV6Lim6xtSuJ56W3RJfQpHML4ZSAeZW1cav0hU1Vuc+qI+G24m3jRhef4CvkgvqyTLX1FioJsyM4OSi1jzkjC8Zpa661XSpWgxmPwNWSwkrFJVCF4myHF6SQBYgosK3nQZ9ZPxJ4GX3d+AogxFUEYPY/orkztqA4XtlA5detq6LAxthmNraS76giiM9t6/p6eNN6W9U4LlDuzfOznm0YByusu5wCH6/nfRnkHudAfQtXaX9PI2Ne3AePe8/s5bqkyG4Kb4VYO1V9rJbQPrmvrf9E8Xsh2TvAKddjK4Dt3+XMd1/rob7JxbANldu/zTP//wmZGPNAJ3wGCFk1h5q2Wi/7oYSoD1MJnC+HtwNHvHRsP+rrS5AJYVosQQ0Iqcouf4T+DNX4VI5/+Gie1VzEY+5CrGlDnRg7eqakFmrcZVIaPJj++wXGZKjV4g/BfDP1NkPKZFVZMty3tLJUGsjVXBX0TIPhuB9RMnbTK1ZJMZJD+dFQD0wr9pi3pjvNO0Gjt9fzC+V/ddLQNW5FAqfdYkpnkEBs+lZ3s2+4JifN1j800GQtwqrT/bSleumJ4JWbbRcIS5uNrm0dS6xRsN3E8Ia6cJyqw6iTWstLlxHvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(186003)(1076003)(86362001)(38100700002)(2616005)(36756003)(2906002)(316002)(6506007)(66556008)(66946007)(66476007)(33656002)(54906003)(6916009)(5660300002)(83380400001)(4326008)(6512007)(26005)(8676002)(6486002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?egR7hryuD1mR/paCZxuxdsSMcZQAYUAi7Kw4P6PbYuymr7AU8xISbj+mjUKd?=
 =?us-ascii?Q?7/z7kBMHjf2L3Hj1lkz+By1vZZRbkVebYozfinUSl6j1Ki99jatPzOticA5+?=
 =?us-ascii?Q?a/yriA97E0dBsBpBOmS0AfIEhVeoJ3TNcUrc0K0/dQ4LJ7IHmm+l5/Cpo9Dp?=
 =?us-ascii?Q?IPWJRUEt8NTztSjkCe1FvQR+JeGf8wu7p1iftonHGqcqD9YIEMAmdsDhVS7c?=
 =?us-ascii?Q?7hM027DRK51sQVd6spTGNqzpwbpAoJpSw4B1BH+0ryDyGWddcsnbdQE5F5FO?=
 =?us-ascii?Q?fU/cYhJVO0NipSpsGq7ZF6MJyspRwG6E1JBdO5nxN/i6megxmgmTEnGyaxe4?=
 =?us-ascii?Q?/5YVH3bLtetv+JQDmvNq5ouHL9sS7+MKQtguiq/r+LpLBM+tvH/kpHQifLoK?=
 =?us-ascii?Q?FMb0tZoxvYHaDz6zn3CtDm09/AL4/5Wgi4jfeeGmwF1qQbH49W+GaZcIChVB?=
 =?us-ascii?Q?6pjpO7nL8YwA5dMpNWIZRn0UdmdOrea6S6FyimDbgV0uNRgsJfirOSwrQpe3?=
 =?us-ascii?Q?yiMd5BQB8nW5fmys7yfYSA5kGwHZeZVO16GZcWjJkTfOJyU6KzIR+sYOZIiq?=
 =?us-ascii?Q?nPvmkNZBDVxKQD8iPGvH4RRnDUNbVOsZgeG8yok0j8OkV2BbEGELnIv/lWeO?=
 =?us-ascii?Q?yBd0t9IkyCOUpTN7DsNRDgNc6WS3Q7B8s+EmHr7O9RGGdnxTx4zxsnczixGW?=
 =?us-ascii?Q?91XoQQ9C+JyuXYdLnCgTNN5SPBxeDnousCZyr7bHC4GJsBJUtGvzfIE0wgFC?=
 =?us-ascii?Q?3bjDFGFci5yCD0NwSwSZh/q5IuUhZAYDRymwGoT8EnFY6d8dMwvGwd17NbvT?=
 =?us-ascii?Q?NKk9aatyCbUuIZO5nlQIvnyfsvEafDuo74OlU+TzCe0vrBQD0gNQetGCiWhE?=
 =?us-ascii?Q?3V67slOINbhB6oYou8SzjDnMIyOSUW8QpXhh62MgTozLYXXRaPo214QKOomo?=
 =?us-ascii?Q?Tul7wkLdM2yez4/bPS4pb/sIbXbGa3v5nLMY1EICLF3//Pcms8Yj+DmBgPnt?=
 =?us-ascii?Q?qE+N+vU2QWegSap2TkhZrWBTFYhWU0gnu8oYGNV9SEDNurpkyUYDFFteGI2R?=
 =?us-ascii?Q?3wPvRSL1CU4DVmJkXWDCmC0T7y/g4PEhybHLDYjgmL6X4tqOigocETGcoZdt?=
 =?us-ascii?Q?+XhRgNWW9YuFCpA0nZBqudgEt11Nq47T+vAE6du1SiIKoRCxEJN4OoSpzTZf?=
 =?us-ascii?Q?TCiRK61LSH6zfdXxzh/xeiNxtH/kczR1N1ZBrd5mjNP32eESx2T++kGx5KxR?=
 =?us-ascii?Q?irUiwdIlnvgA/J23mGd+etYkbmtY0teKYVM8rph8c8L7tjel8OL2vQj0de+5?=
 =?us-ascii?Q?X+ilYkIF3NKGqKsFd47C/fORdbzn12ApAp88ppZYXPHtPiqBelvEpzZkHpqc?=
 =?us-ascii?Q?IPpcy5HVWoOj+0nxS+MXUSlwT/kaB1ItXtG3j3rjxTRyTbxt0Qbpe4zM85tw?=
 =?us-ascii?Q?XSpB0W6EmCkKDayjJlOoS5HqCwI4mIssmxdmR8gcVK38TOnuC10pq3xic8cp?=
 =?us-ascii?Q?ELmNcIniaGRFstPNtUgniO2+kyZhxF4NxYFXrlhDQlxZNWZV65eJA3MoqWyJ?=
 =?us-ascii?Q?MfrHE6OIPh9OlBgHsXrkelZnuvkvgxV+2U3LpZJrAo9NTpJJjtkE0OTZyXaY?=
 =?us-ascii?Q?pVhTBkbKiEuVrcvz4zPIl6i4w+QDLg9FJnYxf3cqMEmes/aA2LcYxIo0HubE?=
 =?us-ascii?Q?MpxAvxADWnJKhEMZ44D4ftZDvSkez7Iy8kTU9IFVBIDdSckD22VXyAHwgl2n?=
 =?us-ascii?Q?Nb6KnZvhWQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6da303-4176-49c8-1d46-08da1ef50b92
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:31:43.7542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8y6z5DGDLb/wgARXEmXBeZcfseWBwKvnDp/3Nrg3r7ss8j7eBdeTPHAV91hApPYy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5931
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 04:36:21PM +0200, Christoph Hellwig wrote:
> On Fri, Apr 15, 2022 at 09:13:01AM -0300, Jason Gunthorpe wrote:
> > > So I got anoyed at this as well a while ago and I still think this
> > > is the wrong way around.
> > 
> > What I plan to do in future is to have differnt ops returned depending
> > on if the file is a struct vfio_group or a struct vfio_device, so it
> > is not entirely pointless like this.
> 
> Uh, I think that is a rather ugly interface.  Why would kvm pass in
> FDs to both into the same interface.

We can do it either way, but IMHO, it is not very different than
passing a socket/file/pipe/etc FD to read() - the list of VFIO files
ops works identically on vfio device or vfio file FDs. The appeal to
multiplex at the file level means we don't need to build parallel
group/device uapi paths and parallel kAPI as well.

Ultimately none of these uses of the file care about what the file is,
these are all 'security proofs' and either FD type is fine to provide
the proof.

> Because that is the sensible layering - kvm already has an abstract
> interface for emulated devices.  So instead of doing symbol_get magic
> of some kind we should leverage it.

Hm, I don't know anthing about kvm's device interface
 
> But I can see how that is something you might not want to do for
> this series.  So maybe stick to the individual symbol_gets for now
> and I'll send a separate series to clean that up?  Especially as
> I have a half-finished series for that from a while ago anyway.

Sure, I only did this because I became sad while touching all the
symbol gets - it really is ugly. It will make the diffstat much worse,
but no problem.

If you have something already then lets avoid touching it too much
here.

Thanks,
Jason
