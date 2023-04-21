Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15536EA5BD
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjDUIWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjDUIWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:22:15 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC93B9020
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 01:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682065316; x=1713601316;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=E3b50K1iYkBhYkdOskIc3ljq2EAGE/LcAf8HsJlbHK4=;
  b=OIRL/O8pGIEemgX/jUCru7G1JqwraTZPoSp0A9xk1iIIErQX3M7bcU2Q
   47a4DHyYmT0J0As1c/5v7JH3oXB7hsJkBOjZCyGfr3IxT2G8j4f5L2gDC
   3Np3g5zIuzBBuldZG8VQijKBg9kjXIuQur8iNsq0Edos5grhc3jdUxh7r
   CmB1G5Fc+mOKul9zD8SVeY7tBxnOyDdaBfMaHgQa97/GVO1QHMu6reoav
   yrw3c8uHiHdBoUmyxskjts8mrc3TYjpBaqhYlCQDVdM1p3FF272PXz+R1
   I+Z2Y9MTevx3ljIcnomAwJGb9Nd8UL3tEqOFKqoBM56EOqQQAAObDpkHJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="408882397"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="408882397"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 01:21:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="866626036"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="866626036"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2023 01:21:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 01:21:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 01:21:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 01:21:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 01:21:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1ZnHpZKiKZHCp3CGu32SEoUqI/HPIpfqt9rGNUAPMNF3bvZZXg9K4R3oVIqnzKJMAWt6zNRlXfAszmh8FIq5rQfTRDe0w+LLk+XQIrSyU3PyqXWV0WEg6CVlKDc3yVQzHFJgMBhNGQKCElPXImhgAikJSqnTStNWYIJ9L8BqKJILTRrjRtBTCoJanE1SWhNrSwqjA05DjD+QJxs+4im40k7WxTJE/FxQAYZCul0in5EqIbEYl+8sxRAnhPUvbnTs53i2MlcP5AAbd+QzJvEfw6CdcT/7DYociao1ZSCewuvDkReTsQj0eQwWVzxNP3lvKl6rnc9fkYhu9N9D6Ee8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHTd9c96tlNjo+xvYEjVn9BkJR2NUhM+wsbAnf4iO4Y=;
 b=NjHPBCFBDY92N3Zj30dWxiCIaN9wyA0A9mdAvJ0bJbFuRlcxr9MZ8FDOYUlLnMmWNa8bgeIe6djKgC2QtXHrnaHmZy49TxG+2xDttkpQhPqrFJqZX/jQsxFdRJN+wdZ29gqkhSl09ii/QaVTUqeVL8TP0UGtYZUkU5bNdrAsbSLiGZcIZ/LdyeQdgV+PngRMRA+kx9EPbfrHwoBRd9CWBAQ0TP9+lrr2fXIAitfXLIte430wXUm9jeeK0u8Xis7bs8wUKsW/gRHIVWxEh7LQ8QJHiQZv/TkIEwerPKtdrneNMOEfvetzlNd4tvKGlVSbp88xyTB4VLAry4/TWLQOWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MN0PR11MB6160.namprd11.prod.outlook.com (2603:10b6:208:3c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 08:21:44 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 08:21:44 +0000
Date:   Fri, 21 Apr 2023 16:21:33 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <kai.huang@intel.com>, <xuelian.guo@intel.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v7 3/5] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Message-ID: <ZEJHjdc1d92h7ZdC@chao-email>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-4-binbin.wu@linux.intel.com>
 <ZD9SMgA2h8XUXsBw@chao-env>
 <e572c85a-02d8-9547-f1a5-f986aa6b4e14@linux.intel.com>
 <22bd3eb6-a3a1-be75-925b-6f50b210a30f@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22bd3eb6-a3a1-be75-925b-6f50b210a30f@linux.intel.com>
X-ClientProxiedBy: SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MN0PR11MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 646b3b5f-5b7c-4c8c-5e35-08db42417072
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DO0KnXWrXy0FkXBT9DGhB2oBuYwn8T5JAeK/pvymGpdFxOERA63zveiWrQ/2S97QmzbbLrTcN+j99eJtKmXKe7a/CiNvpBLBQLvZJBeCnHL0FfL2TeitglmTS9iufUdT0n2lugx2VLcoAjc0yI5otwIFlCLRsSUdsTvMakt5iW8eWyAKOzWhxlvHf4eN8nQ2194UkQfCzGGj/B2TzjZ+pZCkzR4W65/qjOdmlvGLxkNvhfPLdQRXkqdv2RWsWK0XXEtbUhESuQX0VqooIwXSraPWqnLceUWpIAzdOGS+9gFxhmeq1f+PdFOKbwEvKRpkfTR9masIqdjxDko3Lk7JMCEjjNwxf041k/BsobqRJwEQD6EUl5LasEnXKrFQVIBq8THYlXSaRbdjjtVOvjBqHvKU+ky6nFGmd5Q73ceeYtwx0vpkB+7lTXfrNvbtYZSAPwgK7tcXtfQo9OiHZSb5BzTJ6tTC0p5IpFfiljMsanCqlKsQp9X5zNxVg62p5xaNPHtUdkLV/uw0DdWkE9HN6nkWaXuvR7zN81ZwRhwpqzLx7znZmGie9alSH302Wq23
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(39860400002)(396003)(366004)(376002)(346002)(451199021)(478600001)(38100700002)(82960400001)(5660300002)(8676002)(6666004)(6486002)(2906002)(53546011)(9686003)(186003)(6512007)(86362001)(26005)(44832011)(33716001)(6506007)(8936002)(41300700001)(66946007)(66556008)(66476007)(4326008)(6916009)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?DbSFvnOCDkgdfvYnUzNY7x19k0ebf4chzcm/ehTJlI/55e8eEf7Veg5IPp?=
 =?iso-8859-1?Q?odyEc5zzsFSJ7Z60/HnKSnqqaqb+DBzKv1sSYUw49PmvBpx5JhTp6L9p7X?=
 =?iso-8859-1?Q?e54khbTLBVpVYijffv7Iq/XHLYKEcyK1mn7eqijKO0OBF0HVL3SRkq86sn?=
 =?iso-8859-1?Q?IeUik+84GhRqQide5GNgkirbhA9i9eoc40Y33JVEWpINBZyn5qNjd9RaX5?=
 =?iso-8859-1?Q?LtkWgDHyiu56q1cma8aK1JHWvF8aM2kcktkXqGqO4A735D/dFyJFjw4+YX?=
 =?iso-8859-1?Q?KJ6JW3eXwgM1KNQUT8Z+u4Pz8QdqFCJp1U1UXQTxu6uFb+T8TfvAXOvJ0o?=
 =?iso-8859-1?Q?TNU7wccmwQ3dJSQPKHGwBeJ+Kqt+QsOswadp5Ri28miVs8IwcSR7O5LcpT?=
 =?iso-8859-1?Q?juLpAeLS5h3hKNFp6pqUq9fNsbaYW0YNEtIN24qfrxOileQAhUa3iPzNLv?=
 =?iso-8859-1?Q?ac/YHHNj40TFmIZ1CqfoTs3I5F7IgaOLnqHAWSW5ern4NOQ37POJR6uyS5?=
 =?iso-8859-1?Q?WdNHAV+WIXcVb0U6TekTPCR75fvZU3I+/zEQGDbJGk1Sdevr+/djCeOQcs?=
 =?iso-8859-1?Q?O1hURip7GUB/4Vsozf+Pzo4jP/NqBAYsML4XaGntufS+SV9KLfXlV2MNBM?=
 =?iso-8859-1?Q?OLaism6Sm+/OZ89IUGahLUSFYh/EXmGoPASp5RPg6OzzNAz+8Pi68FDFMV?=
 =?iso-8859-1?Q?Ev+VUSVcJ+Z0lbbijboaaC575vSBDBkTOwI3dPirnqIas1JO55fQ9fWKwl?=
 =?iso-8859-1?Q?WWE29R1h/AeprTvOiMVQnTSmbIPlMXSYbOvCnhEcEgrL/xifDsFVT4/dk2?=
 =?iso-8859-1?Q?1udl/xN7AFkXofvBHGQ7iqIkZecAUfFaBRPFcTGmgn8sO+7C9BKJ8LSn3H?=
 =?iso-8859-1?Q?eAULitmAj1oRpEFDqZrpj+3sUskFUDBeZCCgezXtE21EyycZXI9oWCFRy0?=
 =?iso-8859-1?Q?Al7KTcsuCVXYbdnTXXdzhbJA5AvjVH0rttEDrmOM4jJwHctG9SFWbHmYRO?=
 =?iso-8859-1?Q?CzegS0WSUdDqqqe1MgiHOq48V1urmxcfnY+toy3GN4ptofAqEQIATqTfaY?=
 =?iso-8859-1?Q?2WgSh4/eIINuFWaXgA7DYrM8oFQR/cqw5hsHEBUuh1F1tZWKatumRtuamR?=
 =?iso-8859-1?Q?CMjI0+kiwdrgQ0RvTdCT63HZS2cm/WmtRPTAXS7Lm2A+16c+eEvOcU2dQB?=
 =?iso-8859-1?Q?jRWchWsJ6amwMrnA7GP37wKLgrd3EtS9l+rdIO3kqdEwuqZ2qBe1C0cng8?=
 =?iso-8859-1?Q?oJ/g4TpqEv5N5cV7mUaz2KIa28C1vVwyCs/BbpwUgC/LIpSO+Qrmx6NAQk?=
 =?iso-8859-1?Q?n2Vy36HJoPDYX/byIjXSxV0P5MkqJzlMzj5f7ZcguZiszVXdlTTLJCMSMR?=
 =?iso-8859-1?Q?E3OcIEWriYDiwmlSgACe6I1zTIx18N1doBm3zpp/t7lc8fA9L/rT8Epmah?=
 =?iso-8859-1?Q?MB/Ifmp0sFhQtc1tiGh6GqBDxROKgfkutcDavsCjdcbeZTc9D1ZWUFLAGl?=
 =?iso-8859-1?Q?1uI3TihiZ+NaW4lPm7F/CzqAr04Cg0lEQh2iK/vcBF4yxzmm8HARuAEAhd?=
 =?iso-8859-1?Q?2CXgbomMs2hnvt08NUQW04jkg4As0kodp6vmCnsQBJfUYex4JpRhEn4jiV?=
 =?iso-8859-1?Q?nF9uFI5eespxJpHPvaoXrZG9xgGMzWUHKP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 646b3b5f-5b7c-4c8c-5e35-08db42417072
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 08:21:43.4745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDRGpgME51+6XSdhlz1U1EbF0gqp2P0f0sW3vYbdj0OtYgG4RsUWFlqoKzkdgpj/UYOEEAwZphoVjBGR8R+a+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6160
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 03:48:50PM +0800, Binbin Wu wrote:
>
>On 4/19/2023 11:08 AM, Binbin Wu wrote:
>> 
>> On 4/19/2023 10:30 AM, Chao Gao wrote:
>> > On Tue, Apr 04, 2023 at 09:09:21PM +0800, Binbin Wu wrote:
>> > > Introduce a new interface untag_addr() to kvm_x86_ops to untag
>> > > the metadata
>> > >from linear address. Implement LAM version in VMX and dummy version
>> > in SVM.
>> > > When enabled feature like Intel Linear Address Masking or AMD Upper
>> > > Address Ignore, linear address may be tagged with metadata. Linear
>> > > address should be checked for modified canonicality and untagged in
>> > > instrution emulations or vmexit handlings if LAM or UAI is applicable.
>> > > 
>> > > Introduce untag_addr() to kvm_x86_ops to hide the code related to
>> > > vendor
>> > > specific details.
>> > > - For VMX, LAM version is implemented.
>> > >   LAM has a modified canonical check when applicable:
>> > >   * LAM_S48                : [ 1 ][ metadata ][ 1 ]
>> > >                                63               47
>> > >   * LAM_U48                : [ 0 ][ metadata ][ 0 ]
>> > >                                63               47
>> > >   * LAM_S57                : [ 1 ][ metadata ][ 1 ]
>> > >                                63               56
>> > >   * LAM_U57 + 5-lvl paging : [ 0 ][ metadata ][ 0 ]
>> > >                                63               56
>> > >   * LAM_U57 + 4-lvl paging : [ 0 ][ metadata ][ 0...0 ]
>> > >                                63               56..47
>> > >   If LAM is applicable to certain address, untag the metadata bits and
>> > >   replace them with the value of bit 47 (LAM48) or bit 56
>> > > (LAM57). Later
>> > >   the untagged address will do legacy canonical check. So that
>> > > LAM canonical
>> > >   check and mask can be covered by "untag + legacy canonical check".
>> > > 
>> > >   For cases LAM is not applicable, 'flags' is passed to the interface
>> > >   to skip untag.
>> > The "flags" can be dropped. Callers can simply skip the call of
>> > .untag_addr().
>> 
>> OK.
>> 
>> The "flags" was added for proof of future if such kind of untag is also
>> adopted in svm for AMD.
>> 
>> The cases to skip untag are different on the two vendor platforms.
>> 
>> But still, it is able to get the information in __linearize(), I will
>> drop the parameter.
>
>Have a second thought, the flags is still needed to pass to vmx/svm.
>
>If both implementions set the skip untag flag (SKIP_UNTAG_VMX |
>SKIP_UNTAG_SVM)
>or neither sets the skip untag flag,  __linearize() can decide to call
>.untag_addr() or not.
>
>However, in some case, if only one of the implementation need to set the skip
>untag for itself,
>in __linearize(), there is no enough information to tell whether to skip the
>untag or not.

OK. I have no strong preference. An alternative is:

We have only one flag. If AMD and Intel differ in some cases, set the
flag according to the CPU vendor of vCPUs.

if LAM applies to case A while AMD UAI doesn't, do

	if guest CPU is Intel
		set SKIP_UNTAG

for case B to which UAI applies while LAM doens't, do
	
	if guest CPU is AMD
		set SKIP_UNTAG
