Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A987547A2
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 11:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjGOJFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jul 2023 05:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjGOJFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jul 2023 05:05:46 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2111.outbound.protection.outlook.com [40.107.93.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA650E65;
        Sat, 15 Jul 2023 02:05:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJycLyb3XZYUyyrm48J//MV9jGyUWqECEB8xubI0Wxr0hujnW29WUdzKHcB39QF0ifKlAXeBWlgX/v8kOMAFka1QBcywU+B5+Zb9u+k3T9DLSD3DfZtmlIDodOZoHWwt+xk1ygtUaFYLaLN/jQPwjN52/1Ry3f6aI5FdY/upuWGu/QERQSp+JEG2SNaEa3RCslrP8msXDYQUe1HK4oIydM9ivmCLZaYQqulezy3N7WGEbSClESBfPBvVzeEKrqmJsXRDOTSXHQ7H0eQy1JcTvNMEaIT0f3NRsVFznrcmDnsdvn6sVMiWwbq208PVfnrHAhj+z5KKmwzs1OvO/mSyyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yichUeLuSVCgsedkdVaFfnSSys5eeLYJrlW4xf09nlQ=;
 b=O8W+BkeswMfmb9+P0BfCZIxeaX2NwbARsMWBWrlVASB+kXB/AIIuWacpQ0KJCgUUS8kgCmNj85vSpeDG1I6PpD9uiYsgjFe60palwVfZwACjJ+Cfqx0v84WAElFLqRr42qmj/Xjpz/gaTpZpP8ES2pze8PMuKDpSNxvB8Kav8wQtgWDN4PQj5QAcyfDmMyr4r/JRnnXEMgxRLOrzzi9Ced3M2hICOO4Pgv68roI3TiaYXr4SPm0SQ6hiYU83upxBOGbvfhekNmbBQ5wy34XM3yOby97kNlYyHLVLyO7TjDaWza6x6rvHbYU4MMYundKjbRBXj24nsDj69V2j7R/tNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yichUeLuSVCgsedkdVaFfnSSys5eeLYJrlW4xf09nlQ=;
 b=ppNkQiVEJD/8OX8+FhcB1biBIeguVm7+bbAL+TKVRHrO+bhdkSTflV7W0uSn4LXOarMlQw73d+KWnHNbRbEBXc+xPRrp3G1OOI0V6eW3Xh876xt3zq0Jm3OANJbur+YiwIobgi9lFRhu2PjIFOaXWJBphXM2xS3usr/u+hOG7mM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5733.namprd13.prod.outlook.com (2603:10b6:303:177::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.26; Sat, 15 Jul
 2023 09:05:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d23a:8c12:d561:470]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d23a:8c12:d561:470%6]) with mapi id 15.20.6588.028; Sat, 15 Jul 2023
 09:05:39 +0000
Date:   Sat, 15 Jul 2023 10:05:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com
Subject: Re: [PATCH v11 vfio 7/7] vfio/pds: Add Kconfig and documentation
Message-ID: <ZLJhXRdA2a72Cb5/@corigine.com>
References: <20230713003727.11226-1-brett.creeley@amd.com>
 <20230713003727.11226-8-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713003727.11226-8-brett.creeley@amd.com>
X-ClientProxiedBy: LO4P123CA0540.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5733:EE_
X-MS-Office365-Filtering-Correlation-Id: 70d8da17-f77f-4cb6-8ba4-08db8512a8fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UUPMKoLsPByt0d0oAunNjhPJWEbZfixrr7ocUiKlIa5H+9AG3ojbxY7TmQccbu1KPSR9fvdzfBPHP+lwII54xxfOn51WHSz8QTPlo5WemynCwmG6p10rZw3vOzygmNSaJzyv4dkGZ0B96xeZsHaktv+Vi7VzXb0Mdn6A8vcIGJxWx5wIkF3FOvTsSGzSYBotjhYpKqLH0K6BEP/3eiC1Upz4GrbbsXvRQFaoHAX3/QvIWVB0qjJN0Eej4vpmm/pYcU/vJFq0RkoPRY9yRIdg4j7l2h38kJVY6Pvqiuq5rV4A5Dsf06PsKu8vK9YOTsyYPZEly62Wtyrn1nodo0qYmdPhZR03vq3nwbq1R2ltBaRIgpt95p2Rs7cAYZX1M+Xh+RsHj/LWuoPG9n2mSm2C3CbSjkToKUUP9Ziyx7sgujrBUxNWsnhSyNepGiQ4jXQUfRPzefZAa7/V+hE9kQu+2JH5lIZaAJfGqAAb47KRzTdYx5BLExOBFf2Z224vOhzWpvPQdnmJw9KFsL8/rOrCbjj+7t5QzjY1WJad7/JgMWOv3kztVyXKvUzknRrW5p6X9GwdfeevMP1puiTmUMYeZtnSCLQS0NqB9usvIkKmdW0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(376002)(346002)(39830400003)(451199021)(2906002)(38100700002)(6512007)(186003)(83380400001)(2616005)(26005)(6506007)(5660300002)(86362001)(8676002)(8936002)(36756003)(44832011)(478600001)(6486002)(6666004)(316002)(41300700001)(4326008)(6916009)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vA0cCqOCQ1K4Rhin4KbSq0YN8w9CHZ1Ky6zvhnrJgiG0UxBeE9LBaiWnlinq?=
 =?us-ascii?Q?TGhurgF9Gktoxm5+gu2uoqY1W6NQyhSsAzQQ/dgbU3o+vF8bdRVWK95wYWys?=
 =?us-ascii?Q?znp67XevtPOMBS3rDE4XYmSeXLOD/QSRM7yWwZ5kCXq5z5eiMHbmMc1BTLnp?=
 =?us-ascii?Q?8G40iaKQJ4u1ZKXvXI+qgY5vze6ypoyRjajBOosQIBKo9fIqoSPDHleIO5S9?=
 =?us-ascii?Q?ZWEADUNL4Uf+QZDQGQ1rNNtfg/EOBuICSargMPeJipUiSolUjQmsTjyyy0t8?=
 =?us-ascii?Q?bco+gwd7EDcRDxHMv8QUyHQzBLQPpWw8N13mJ1fOILUgacpjKXQ5zSbN+6Oh?=
 =?us-ascii?Q?d3+mko+T1nxIoDvFI1yZrSXiBdiUSa/2YZOFR25QHoxtttuo3GGemLuaVd4M?=
 =?us-ascii?Q?8iYKLOmoZBX2UXx7Q7gIQv2983fdMbpZI8GB0OkF6IsACI+ORPFhaM3LAvKm?=
 =?us-ascii?Q?YL/0LppQvnAsH16xKo83qzP8LrKh+S1f6LpVjRJHxfb3xr2HQlWJESj3valT?=
 =?us-ascii?Q?zKqfMGORRThRlDLIx0Fh3CNZvMyWo0nn3OZPr1lVL284Z7XgtpTb2lbdEqTo?=
 =?us-ascii?Q?FKHi8+R4a1Jl/xsM0Nv3NZXqquSPivYWTGjBbus/Gpj5/9h78Eo7u6KJYuny?=
 =?us-ascii?Q?wLkcwWNqlwwUxgbodux5oGkREylp06efS7nHnCQv1Lkawn4eN42aWHnlD9mb?=
 =?us-ascii?Q?OiAz9AJpWY0UsFNf7y5gP7IDLl0EpimDQHZlwiE/Gx1ZN8ArkiqWtwptxQDo?=
 =?us-ascii?Q?oJvQW3hrxmRqK6v95OdNlF/mw74zAJcJJhewt4gnzq1rUbkznZNUht0dF3Kn?=
 =?us-ascii?Q?u4I3EBGhsxr264aPkBLUM3PoWBlv34zY8rycIv+Uhnjd0BafeqtxRs4/Uvn3?=
 =?us-ascii?Q?SYGPULGzLGQcAL2ZY/x+eJ0XOEWISnggLf5mRn7m5HL7NkV61lkSpjfvfXS7?=
 =?us-ascii?Q?FFnrDx3Mkn5tIgK6ue0Ih31/pEg6kNy+gHIxsyoBaaMM2NNRhGJiKwqCu90i?=
 =?us-ascii?Q?jdqhVuHGZ+F/lFl0RbZQDqdmKJgaeYO1ionkEaUqrkbsDtgaxWPX/x0bxhFj?=
 =?us-ascii?Q?J2OR0fVm5Bcxei0vQ+fPweAtcgdw0V6Uq1Ir7ng1ft/RWpcH8PHiTh6KXVAT?=
 =?us-ascii?Q?+VLT9E1xW4HOxgcsrTBuDMq7si89WpUghJRtsf3ZygmjaFS6Zyu9oA1S7mwh?=
 =?us-ascii?Q?xXtZvrZ3K6qN5a/RvFqnxnJjiFUSW0+kaBAwrekaz/WH16+DZrELL8BepLcN?=
 =?us-ascii?Q?BHs23sXKdN6ygZbf6Ld4FJ8PjtspcPKYJg8K6XKkDbL9YsvXtqYqdyRkAWeb?=
 =?us-ascii?Q?wsC45843hgYalQKanQOiI6RMxX0kawXiLx7TZvA107IlZvbXB54+IaN61ajC?=
 =?us-ascii?Q?rPd0CqS4xJHpA5uVtoJ5LSz3q2mY087kUcOHh/mjbIMN69NUK/EJ7gwIdLuq?=
 =?us-ascii?Q?Y6F2qfMBfXMNU7fJyDwAibPF4nJEW1Go1N7zx3qxP7B8bTH4m5CFWPPiJGc7?=
 =?us-ascii?Q?VY55mM176DjrwMyN8U0sHXJ08zKq4T8jAs311+Y7nrm6bxbfa9EsJiPo2Oqd?=
 =?us-ascii?Q?ByoHEqbSQxVghVuy+yWe6Km+RhHXjlLF3HsJCJfbHPujq8wwIdpKijGq62FG?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d8da17-f77f-4cb6-8ba4-08db8512a8fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2023 09:05:39.6822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7K8dUUa3zHGP9GxCYPE7W2oK4BwfGX1NUleWqW8y3WtbQG/v/aC97LexHhoqgqqvhDhyTjh4GGcparz6zPKvPRgAftYvSf1FfcEnog3F0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5733
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 05:37:27PM -0700, Brett Creeley wrote:
> Add Kconfig entries and pds-vfio-pci.rst. Also, add an entry in the
> MAINTAINERS file for this new driver.
> 
> It's not clear where documentation for vendor specific VFIO
> drivers should live, so just re-use the current amd
> ethernet location.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../ethernet/amd/pds-vfio-pci.rst             | 79 +++++++++++++++++++
>  .../device_drivers/ethernet/index.rst         |  1 +
>  MAINTAINERS                                   |  7 ++
>  drivers/vfio/pci/Kconfig                      |  2 +
>  drivers/vfio/pci/pds/Kconfig                  | 19 +++++
>  5 files changed, 108 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
>  create mode 100644 drivers/vfio/pci/pds/Kconfig
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst b/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
> new file mode 100644
> index 000000000000..7a6bc848a2b2
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds-vfio-pci.rst
> @@ -0,0 +1,79 @@

...

> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
> index 94ecb67c0885..804e1f7c461c 100644
> --- a/Documentation/networking/device_drivers/ethernet/index.rst
> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
> @@ -16,6 +16,7 @@ Contents:
>     altera/altera_tse
>     amd/pds_core
>     amd/pds_vdpa
> +   amd/pds_vfio
>     aquantia/atlantic
>     chelsio/cxgb
>     cirrus/cs89x0

Sorry for not noticing this, but there seems to be a missmatch
between 'amd/pds_vfio' above, and the name of the file in
question. Perhaps the file should be renamed pds_vfio.rst?

'make htmldocs' reports:

 .../index.rst:10: WARNING: toctree contains reference to nonexisting document 'device_drivers/ethernet/amd/pds_vfio'
 .../amd/pds-vfio-pci.rst: WARNING: document isn't included in any toctree



