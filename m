Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA6E3EAB60
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 21:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbhHLTv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 15:51:57 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:48480
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236114AbhHLTv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 15:51:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3XZ/LHL3/R4amcfFiXRfQ8xmfxQRcbkZE0gA5cOeokXVWTkOxACtzrM8NjxhR71O/cMu9PjudG1yf7NuEFhflNHmfnfwnPkGro2ZLPhu9BPmQeFdSxo+qf4katYgfJb2zW9kO44NAfVnBYAal2BulUj8p2wDfiVMi/WTxl8Wq2tE780QfCdllgxoSRbHf6myCyd5FCbQSmcj28AG6IjBo1yAi7bEVbN4Q14ckm/09KlFSSrd8zFhJvSE4pbXobu9W2OsstuFY0zj0lJNEC8HOxT4sBBNO1pA5dm6FO2fNLAk4fhTxkdejPZqbzlG/h+FeLU/N4a5GZe87wO+3z/hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4V13jeISzZIVwJZJ63tOEkqMMW9GoFkucYac+tncRpA=;
 b=h+RGQC538BSX8WJJn+K6nj5QmX6qhV01mKWxZQ8FeJymtIDR/FRUPSUEMiBwGRmtlOmCcGHc9mQTceZaV/lLhhRDZd8ncvPRcf0FX4CAYqzQPQ716k0vAhlpHNWFOdvIMHuXpNR5tKv2IPRKfa/f737zSbspLiPLYUN4g9snn08IZNQXTWAKrHBTmm99R02ZJewusYyyae9h+CyQPORKyHVU0/iQS2bqrKK6oyuwW9awV3xjka1dfBs0AtnxDTrNkoGB0DBflO/H+VQ/4XLxipGMMpw8FWECDxmZCI+kbOAy1HLKV/fnT/ALzoi/FO+M8wOwQ+eoqzWYbqpngAjcTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4V13jeISzZIVwJZJ63tOEkqMMW9GoFkucYac+tncRpA=;
 b=OnIpnzq3vZhvqXQKdFZ9GiFq0XKwFgWuNjHCYuJOkLBuLJvi5UPUmX8aGTo3N5YWTvsABxt3Z1FiKmT8LdLOPijMAfD2kloMOCU8iZBTK1o6hxRRgVZR7UwZYfIJ0RTANZAvlABbm8Hup8yvU0EEYTqDenXXqO6pXpRR1W4Sq3E95hKcHeu9tB7YBss6WAMfxS58NKAR0jA7Ts+kd3tItiTe9k0NzXIgs6snbvwb2E66wSq9l8yLRMjCoxvYOwLlT5kV1xM0SJ90IWA3NgM9TX4NLlg5+u0PV1Jnn0MWJzseo9Cnrlen45EMasWBHkcvHrRs43ZJliVks1sQBv7jFw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.16; Thu, 12 Aug 2021 19:51:28 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 19:51:28 +0000
Date:   Thu, 12 Aug 2021 16:51:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210812195126.GA4026@nvidia.com>
References: <20210812132728.GB8367@nvidia.com>
 <20210812155707.GA2464922@bjorn-Precision-5520>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812155707.GA2464922@bjorn-Precision-5520>
X-ClientProxiedBy: BL0PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:208:91::38) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR05CA0028.namprd05.prod.outlook.com (2603:10b6:208:91::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.9 via Frontend Transport; Thu, 12 Aug 2021 19:51:28 +0000
Received: from jgg by jggl with local (Exim 4.94)       (envelope-from <jgg@nvidia.com>)        id 1mEGje-0001Gp-KA; Thu, 12 Aug 2021 16:51:26 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1affb811-fd27-434f-b4c5-08d95dca9305
X-MS-TrafficTypeDiagnostic: DM6PR12MB5565:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB5565D943F228A003E210C0D9C2F99@DM6PR12MB5565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBgmOTaJ/SZU4kTMJ+YjVB/uQh044xXb3vg3SOoOtaeIPxLxSbNDqYkczY1o1fUo2Uz5J4crzS4+LHY36axm56kIHuKEJXiZqT86dOwh27ARjNvSPNIGxtESBOIInOWaYkdO0bY74MYaHdUcnedvjhgWutRyFN8mb+QZ7AFbRJcdxvBwaFaOxOVKzSTXDNw/d6psqfLoQDev9SHfHry+nSBE/x3NUw4h/xJPCkmg5DUhynnW9mfKVFD2W4yPfV4HdYSlZzS8IFSe0YwD6ExelliFveZbyBX0ICh1FUzLjvQxgPpmSgDbG5hECJtz+omQ26ffXM5uleZrYI6m/IqAAFhUe0ge5YKA/AkKgdTC9XIoGNXwbd58BS/xJaZ3XZ8hUyHyID6WUCrZscF8X/DvvCKFY65y+4yFyM1iRmxYktjaobUE3znurEgC3LgF4wzQ6CR5yuTSmVu01SOWDupN5YvSLh68WYNAyrnTRNVlhNrFdjijUSn1Il0TXPzJuqbuW0t85gNLUdypXKPoEIKZCGr66ToORZxjLfmt2kFeOms0NMTg/W6bFkwk39ojSHnVRPZtdytJofn9y8XBh0gKbe1FQMVOpTk9eLev48quzbM3m9iNwpFHny8oui5bIPxQpoUMwz3m92lnyeFidjCInQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(6916009)(2906002)(107886003)(478600001)(33656002)(7416002)(86362001)(186003)(316002)(26005)(66556008)(66476007)(8936002)(426003)(66946007)(8676002)(36756003)(83380400001)(4326008)(38100700002)(9786002)(9746002)(1076003)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?anVxCu1lS50HMlIxM/1dtgSUXvO0q1a/iMeavz7ADuwextrlHplWFHzWhebz?=
 =?us-ascii?Q?d5DD/tTSAZBJ93hH+cktzwZsizhVOlfWjfINicUfvnHfuQT5diwUH8p2RBuH?=
 =?us-ascii?Q?IVi0GOJ0O7R/EqWchEtAnlLA5QSstdkjKwRsQNsYc5ygapWjv4Mx/ILE4Mmr?=
 =?us-ascii?Q?fc9SEAApOdPD7sO0KuyatkfUsH5deBquIXTQ580gRrUDzLVA+yKCsp2F/hQY?=
 =?us-ascii?Q?KeVzqs/mrCqvfxu2XCqj+6kmNJ+F2wXjXp8ruMWBqD3aMRKxsV3EhqQvRjeb?=
 =?us-ascii?Q?OoqaULy3kCyNhQel3KBZN0s3yVQIgUK+uunLU892WFV1iS5XKd76p2nxs2/v?=
 =?us-ascii?Q?pfLfVPvTvzory5sGvvOeTBkjXw44NNM68dwP7O8rGIJJGRwzWp4zG88O09tq?=
 =?us-ascii?Q?apG0soL8JFknPdlT0ntcGSs7bSVI5q1lio08Cepg2t72JALbxZ9GkIjziIbe?=
 =?us-ascii?Q?jNx4brkOvZzbKRXSnMJXmmDL09pFv7a5DuW9+E+OKmby+1ag4Xs72thI/rh3?=
 =?us-ascii?Q?VASnfbao3frkabfDFICTTQ1JQJFEA6T/iDr7isnnXCxAgX831zBsB9XdGBnZ?=
 =?us-ascii?Q?YO/eNoEuMQLwNLT6k8fOkUu+4roJsR6/PeOZ5AgYEmOjIQ5zwJApgJwwto3O?=
 =?us-ascii?Q?rh99CIi3Kr1isxJ4fsKG+B9MRTmawXsiAwEHlPVXFXXTOAjtqrQUZ8wzQsZL?=
 =?us-ascii?Q?zgDL6Afogtcd+6ZzqiREUikw6a3eFHo1lxYP/2Yci5cq4eAw2vooTMu+RDbi?=
 =?us-ascii?Q?jLFfZv6zzXPRmee4YZIHnA7Cin1TySSDzunmEJBiskCw/KVG8eqPyyoZBan1?=
 =?us-ascii?Q?75/zajHIEhzFXdKNv3O336GRd4pgNKF4oi9Td407CpLrdKzzQ1s942dmjWcL?=
 =?us-ascii?Q?eZD3MDTtDK/Df8840v/DwnCB/00VwEKTxJ5XLjc2GAGmW0eTT2tFxjBzEJUM?=
 =?us-ascii?Q?WWcjYOFZ9x+RU4J35HioVXKhnGUgxUXtTzEd5dfZC0pwYIY4hEXljC2AVRvb?=
 =?us-ascii?Q?gyI0vlqvGjZXdP1Zo6jW+gvPTR4gxw/UVgCoa3At02fZa46B35LpyA5XEGfW?=
 =?us-ascii?Q?zNZXPmBC0PBr6QnLy1J/2+eSDIwI1BIBFLR9LiFcgHF5xra9UrFr62Y4diiP?=
 =?us-ascii?Q?Oh4UEIyaNxpGTsnOTUz3zagkRcBNRBdBiHlpFUyjL7qHG2qwbNt6nEdyxz7H?=
 =?us-ascii?Q?g/lnK5xEQmqzsAKHKzxQ7zK41Zyw4OXkWIoGH7L776yq5AxC53gQ6JXnQHZ7?=
 =?us-ascii?Q?9TOa/kBIhsBiM6WyjIdcp+PmMFMZumA6abvrYNksUrOC/opqb8S9cpN+RHLm?=
 =?us-ascii?Q?m05IvLfM/lQr9s4yVd1dASmN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1affb811-fd27-434f-b4c5-08d95dca9305
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 19:51:28.3367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HAhiOoRv/oHrqatZtepUHKFMbb/bJKdqycxxq+Usce/ALQ3/TTBc7iLanEX5CEWF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5565
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 12, 2021 at 10:57:07AM -0500, Bjorn Helgaas wrote:
> On Thu, Aug 12, 2021 at 10:27:28AM -0300, Jason Gunthorpe wrote:
> > On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
> > > On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
> 
> > > Do the other bus types have a flag analogous to
> > > PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
> > > other bus types, it'd be nice if the approach were similar.
> > 
> > They could, this series doesn't attempt it. I expect the approach to
> > be similar as driver_override was copied from PCI to other
> > busses. When this is completed I hope to take a look at it.
> 
> I think this would make more sense as two patches:
> 
>   - Add a "PCI_ID_DRIVER_OVERRIDE" flag.  This is not VFIO-specific,
>     since nothing in PCI depends on the VFIO-ness of drivers that use
>     the flag.  The only point here is that driver id_table entries
>     with this flag only match when driver_override matches the driver.

This would require using two flags, one to indicate the above to the
PCI code and another to indicate the vfio_pci string to
file2alias. This doesn't seem justified at this point, IMHO.

>   - Update file2alias.c to export the flags and the "vfio_pci:" alias.
>     This seems to be the only place where VFIO comes into play, and
>     putting it in a separate patch will make it much smaller and it
>     will be clear how it could be extended for other buses.

Well, I don't want to see a flag called PCI_ID_DRIVER_OVERRIDE mapped
to the string "vfio_pci", that is just really confusing.

Other busses need to copy pretty much the entire patch, there isn't
really any sharing here. I don't see splitting as good here..

What this logically wants is the match entry to have a

  const char *file2alias_prefix

Which would be set to "vfio_", but I'm not keen to bloat the match
entry further to do that..

> > The full sequence is more like:
> > 
> >      echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
> >      echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
> >      echo 0000:01:00.0 > /sys/bus/pci/drivers_probe
> 
> Thanks a lot for this!  I didn't know about drivers_probe (see
> drivers_probe_store()), and it doesn't seem to be documented anywhere
> except sysfs-bus-usb, where it's only incidental to USB.

Okay, lets make the changes in the commit message, it does help

Jason
